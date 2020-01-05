# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit multilib-minimal python-any-r1

DESCRIPTION="Handler library for evdev events"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/libevdev/ https://gitlab.freedesktop.org/libevdev/libevdev"

if [[ ${PV} == 9999* ]] ; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/libevdev/libevdev.git"
	inherit autotools git-r3
else
	SRC_URI="https://www.freedesktop.org/software/libevdev/${P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc static-libs"

BDEPEND="
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )
	virtual/pkgconfig
"
RESTRICT="test" # Tests need to run as root.

src_prepare() {
	default
	[[ ${PV} == 9999* ]] && eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf $(use_enable static-libs static)
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
	if use doc ;then
		local HTML_DOCS=( doc/html/. )
		einstalldocs
	fi
}
