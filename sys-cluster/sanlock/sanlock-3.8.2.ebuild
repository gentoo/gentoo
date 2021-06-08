# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{7,8} )
inherit linux-info python-r1 systemd

DESCRIPTION="shared storage lock manager"
HOMEPAGE="https://pagure.io/sanlock"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2+ GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	acct-user/${PN}
	acct-group/${PN}
	dev-libs/libaio
	sys-apps/util-linux
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="${DEPEND}"

PATCHES=(
	${FILESDIR}/sanlock-fence_sanlock-LDFLAGS.patch
)

pkg_setup() {
	local warning="You need to have CONFIG_SOFT_WATCHDOG enabled in your kernel for wdmd"
	if linux_config_exists; then
		if ! linux_chkconfig_present SOFT_WATCHDOG; then
			ewarn ""
			ewarn "$warning"
			ewarn ""
		fi
	else
		ewarn ""
		ewarn "Could not be checked automatically: $warning"
		ewarn ""
	fi
}

src_compile() {
	for d in wdmd src fence_sanlock reset; do
		cd $d; emake; cd ..
	done
	if use python; then
		cd python; python_foreach_impl emake; cd ..
	fi
}

src_install() {
	for d in wdmd src fence_sanlock reset; do
		cd $d; emake DESTDIR="${D}" LIBDIR="${EROOT}usr/$(get_libdir)" install; cd ..
	done
	if use python; then
		cd python; python_foreach_impl emake DESTDIR="${D}" install; cd ..
	fi

	# config
	dodir /etc/wdmd.d
	dodir /etc/sanlock
	insinto /etc/sanlock
	doins src/sanlock.conf

	# init
	newconfd init.d/sanlock.sysconfig sanlock
	newconfd init.d/wdmd.sysconfig wdmd
	newinitd "${FILESDIR}"/sanlock.initd sanlock
	newinitd "${FILESDIR}"/wdmd.initd wdmd
	#doinitd ${FILESDIR}/sanlk-resetd.initd
	#doinitd ${FILESDIR}/fence_sanlockd.initd

	# systemd
	systemd_newunit init.d/sanlock.service.native sanlock.service
	sed -i 's,^ExecStartPre=,#ExecStartPre=,' init.d/wdmd.service.native
	systemd_newunit init.d/wdmd.service.native wdmd.service
	systemd_dounit init.d/sanlk-resetd.service
	#systemd_dounit ${FILESDIR}/fence_sanlockd.service
}
