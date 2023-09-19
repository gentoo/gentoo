# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit linux-info python-any-r1 systemd toolchain-funcs

DESCRIPTION="A tool to log and decode Machine Check Exceptions"
HOMEPAGE="http://mcelog.org/"
SRC_URI="https://github.com/andikleen/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-mcelog )"
DEPEND="${PYTHON_DEPS}"

# TODO: add mce-inject to the tree to support test phase
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-194-musl-fix.patch
	"${FILESDIR}"/${PN}-0.8_pre1-timestamp-${PN}.patch
	"${FILESDIR}"/${PN}-129-debugflags.patch
)

pkg_pretend() {
	if [[ ${MERGE_TYPE} != buildonly ]]; then
		local CONFIG_CHECK="~X86_MCE"
		kernel_is -ge 4 12 && CONFIG_CHECK+=" ~X86_MCELOG_LEGACY"
		check_extra_config
	fi
}

src_prepare() {
	default
	tc-export CC
	python_fix_shebang genconfig.py
}

src_install() {
	default

	insinto /etc/logrotate.d/
	newins ${PN}.logrotate ${PN}

	newinitd "${FILESDIR}"/${PN}.init-r1 ${PN}
	systemd_dounit ${PN}.service

	dodoc *.pdf
}
