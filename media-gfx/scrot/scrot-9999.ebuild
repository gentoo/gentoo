# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit shell-completion

DESCRIPTION="Screen capture utility using imlib2 library"
HOMEPAGE="https://github.com/resurrecting-open-source-projects/scrot"
if [[ ${PV} == *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/resurrecting-open-source-projects/${PN}"
	inherit autotools git-r3
	LIVE_BDEPEND="dev-build/autoconf-archive"
else
	SRC_URI="https://github.com/resurrecting-open-source-projects/${PN}/releases/download/${PV}/${P}.tar.bz2"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="feh"
SLOT="0"

# imlib2[X] needed for imlib_create_image_from_drawable, bug #835582
# imlib2[png] not technically requried, but it's the default format used by
# scrot, so unconditionally depend on it to avoid breaking basic commands which
# don't specify an output format.
RDEPEND="
	media-libs/imlib2[X,filters(+),text(+)]
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libXinerama
	media-libs/imlib2[png]
"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	${LIVE_BDEPEND}
	virtual/pkgconfig
"

DOCS=(
	AUTHORS ChangeLog README.md FAQ.md
)

src_prepare() {
	default

	[[ ${PV} == *9999* ]] && eautoreconf
}

src_install() {
	default

	dozshcomp  etc/zsh-completion/_scrot
	dobashcomp etc/bash-completion/scrot
}
