# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit linux-info python-r1 systemd

DESCRIPTION="shared storage lock manager"
HOMEPAGE="https://pagure.io/sanlock"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2+ GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 sparc x86"
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
BDEPEND="sys-apps/which"

PATCHES=(
	"${FILESDIR}/sanlock-fence_sanlock-LDFLAGS.patch"
	"${FILESDIR}/sanlock-3.8.4-implicit-func-decls.patch"
)

CONFIG_CHECK="~SOFT_WATCHDOG"

src_compile() {
	for d in wdmd src fence_sanlock reset; do
		emake -C ${d}
	done

	if use python; then
		python_foreach_impl emake -C python
	fi
}

src_install() {
	for d in wdmd src fence_sanlock reset; do
		emake -C ${d} DESTDIR="${D}" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	done

	if use python; then
		python_foreach_impl emake -C python DESTDIR="${D}" install
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
	sed -i 's,^ExecStartPre=,#ExecStartPre=,' init.d/wdmd.service.native || die
	systemd_newunit init.d/wdmd.service.native wdmd.service
	systemd_dounit init.d/sanlk-resetd.service
	#systemd_dounit ${FILESDIR}/fence_sanlockd.service
}
