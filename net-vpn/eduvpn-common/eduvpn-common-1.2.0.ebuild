# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_PEP517=setuptools
DISTUTILS_EXT=1
inherit distutils-r1 go-module linux-info

DESCRIPTION="Linux client and Python client API for eduVPN"
HOMEPAGE="https://www.eduvpn.org/"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eduvpn/eduvpn-common.git"
else
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/eduvpn.asc
	inherit verify-sig
	SRC_URI="
		https://github.com/eduvpn/eduvpn-common/releases/download/${PV}/eduvpn-common-${PV}.tar.xz
		verify-sig? ( https://github.com/eduvpn/eduvpn-common/releases/download/${PV}/eduvpn-common-${PV}.tar.xz.asc )
		https://www-user.tu-chemnitz.de/~hamari/eduvpn/${P}-deps.tar.xz
	"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="openvpn wireguard"
RESTRICT="test"

RDEPEND="
	openvpn? ( net-vpn/openvpn )
"

if [[ ${PV} != *9999* ]] ; then
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-eduvpn )"
fi

wrap_python() {
	local phase=$1
	shift

	pushd wrappers/python >/dev/null || die
	distutils-r1_${phase} "$@"
	popd >/dev/null || die
}

pkg_pretend() {
	if use wireguard; then
		CONFIG_CHECK="~WIREGUARD"
		WARNING_WIREGUARD="You must enable WIREGUARD to use wireguard."
		check_extra_config
	fi
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

src_prepare() {
	default

	mkdir -p wrappers/python/eduvpn_common/lib || die

	wrap_python ${FUNCNAME}
}

src_compile() {
	default
	wrap_python ${FUNCNAME}
}

src_test() {
	default
	wrap_python ${FUNCNAME}
}

src_install() {
	# The shared library is installed within the python package. There is no
	# need to call the default routine.
	wrap_python ${FUNCNAME}
}
