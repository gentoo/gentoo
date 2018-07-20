# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/wayland/wayland-protocols.git"
	EXPERIMENTAL="true"

	inherit git-r3 autotools
else
	inherit autotools
fi

DESCRIPTION="Wayland protocol files"
HOMEPAGE="https://wayland.freedesktop.org/"

if [[ $PV != 9999* ]]; then
	SRC_URI="https://wayland.freedesktop.org/releases/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE=""

RDEPEND="dev-libs/wayland"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default

	[[ ${PV} == 9999 ]] && eautoreconf
}

src_test() {
	export XDG_RUNTIME_DIR="${T}/runtime-dir"
	mkdir "${XDG_RUNTIME_DIR}" || die
	chmod 0700 "${XDG_RUNTIME_DIR}" || die

	default
}
