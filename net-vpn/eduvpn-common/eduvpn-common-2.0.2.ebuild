# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 go-module linux-info

DESCRIPTION="Linux client and Python client API for eduVPN"
HOMEPAGE="https://www.eduvpn.org/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eduvpn/eduvpn-common.git"
else
	# Development Versions use a different release signing key
	if [[ $(ver_cut 2) == 99 || $(ver_cut 3) == 99 ]] ; then
		VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/eduvpn-dev.asc
	else
		VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/eduvpn.asc
	fi
	inherit verify-sig
	SRC_URI="
		https://github.com/eduvpn/eduvpn-common/releases/download/${PV}/eduvpn-common-${PV}.tar.xz
		verify-sig? ( https://github.com/eduvpn/eduvpn-common/releases/download/${PV}/eduvpn-common-${PV}.tar.xz.asc )
		https://www-user.tu-chemnitz.de/~hamari/eduvpn/${P}-deps.tar.xz
	"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="openvpn"
RESTRICT="test"

RDEPEND="
	openvpn? ( net-vpn/openvpn )
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND="verify-sig? ( >=sec-keys/openpgp-keys-eduvpn-20240307 )"
fi

wrap_python() {
	local phase=$1
	shift

	pushd wrappers/python >/dev/null || die
	distutils-r1_${phase} "$@"
	popd >/dev/null || die
}

pkg_pretend() {
	CONFIG_CHECK="~WIREGUARD"
	WARNING_WIREGUARD="You must enable WIREGUARD to use wireguard."
	check_extra_config
}

src_unpack() {
	# go dependencies are not signed
	if use verify-sig; then
		pushd "${DISTDIR}" > /dev/null || die
		verify-sig_verify_detached \
			${P}.tar.xz{,.asc}
		popd > /dev/null || die
	fi
	default_src_unpack
}

src_compile() {
	default

	# Install shared library into the python directory so the python packaging
	# magic can find it.
	pushd wrappers/python >/dev/null || die
	emake install-lib
	popd >/dev/null || die

	wrap_python ${FUNCNAME}
}

src_test() {
	default
	wrap_python ${FUNCNAME}
}

src_install() {
	wrap_python ${FUNCNAME}
}
