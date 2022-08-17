# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN=${PN}-scheme
MY_PV=${PV}  # May be tagged incorrectly, see bug #858245
MY_P=${MY_PN}-${MY_PV}

inherit toolchain-funcs

DESCRIPTION="Minimal Scheme implementation for use as an extension language"
HOMEPAGE="http://synthcode.com/scheme/chibi/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ashinn/${MY_PN}.git"
else
	SRC_URI="https://github.com/ashinn/${MY_PN}/archive/${MY_PV}.tar.gz
				-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}"/${MY_P}
fi

LICENSE="BSD"
SLOT="0"

src_configure() {
	tc-export CC

	export PREFIX="${EPREFIX}/usr"
	export LIBDIR="${EPREFIX}/usr/$(get_libdir)"
	export SOLIBDIR="${EPREFIX}/usr/$(get_libdir)"

	# If "ldconfig" exists it is ran, overwrite it with "LDCONFIG" variable.
	export LDCONFIG="0"
}

src_install() {
	default

	dosym ${MY_PN} /usr/bin/${PN}
}
