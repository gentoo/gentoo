# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
inherit flag-o-matic linux-info distutils-r1 systemd

DESCRIPTION="shared storage lock manager"
HOMEPAGE="https://pagure.io/sanlock"
SRC_URI="https://releases.pagure.org/${PN}/${P}.tar.gz"

LICENSE="LGPL-2+ GPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="python"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

DEPEND="
	dev-libs/libaio
	sys-apps/util-linux
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="
	acct-user/${PN}
	acct-group/${PN}
	${DEPEND}
"

PATCHES=(
	"${FILESDIR}/sanlock-3.8.4-implicit-func-decls.patch"
)

CONFIG_CHECK="~SOFT_WATCHDOG"

src_compile() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/863734
	# https://pagure.io/sanlock/issue/10
	filter-lto

	for d in wdmd src reset; do
		emake -C ${d}
	done

	if use python; then
		pushd python
		distutils-r1_src_compile
		popd
	fi
}

src_install() {
	for d in wdmd src reset; do
		emake -C ${d} DESTDIR="${D}" LIBDIR="${EPREFIX}/usr/$(get_libdir)" install
	done

	if use python; then
		distutils-r1_src_install
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

	# systemd
	local utildir="$(systemd_get_utildir)"
	exeinto "${utildir#"${EPREFIX}"}"
	doexe init.d/systemd-wdmd
	systemd_newunit init.d/sanlock.service.native sanlock.service
	systemd_dounit init.d/wdmd.service
	systemd_dounit init.d/sanlk-resetd.service
}
