# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=setuptools

inherit optfeature distutils-r1 shell-completion

DESCRIPTION="Neofetch with LGBTQ+ pride flags!"
HOMEPAGE="https://github.com/hykilpikonna/hyfetch"
if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/hykilpikonna/hyfetch.git"
	inherit git-r3
else
	SRC_URI="https://github.com/hykilpikonna/${PN}/archive/${PV}/${P}.tar.gz"
	KEYWORDS="amd64 arm64"
fi

LICENSE="MIT"
SLOT="0"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4.11-pyproject.patch
	"${FILESDIR}"/${PN}-1.4.11-neofetch.patch
)

RDEPEND="
		dev-python/typing-extensions[${PYTHON_USEDEP}]
"

python_install() {
	newbashcomp hyfetch/scripts/autocomplete.bash ${PN}
	newzshcomp hyfetch/scripts/autocomplete.zsh _${PN}

	distutils-r1_python_install

	dodir /usr/bin/
	cp neofetch "${D}/usr/bin/neowofetch" || die

	rm -r "${D}/usr/lib/${EPYTHON}/site-packages/hyfetch/scripts" || die
}

pkg_postinst() {
	optfeature "displaying images" "media-libs/imlib2 www-client/w3m[imlib]"
	optfeature "gpu detection" sys-apps/pciutils
	optfeature "thumbnail creation" media-gfx/imagemagick
	optfeature "wallpaper" media-gfx/feh x11-misc/nitrogen
	optfeature "window size" x11-misc/xdotool "x11-apps/xwininfo x11-apps/xprop" "x11-apps/xwininfo x11-apps/xdpyinfo"
	elog "The standard neofetch is installed as 'neowofetch', to avoid name conflicts."
	elog "So if you do not wish to use the pride flag functionality, you can call the"
	elog "tool that way instead."
}
