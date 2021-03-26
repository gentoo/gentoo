# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{7,8,9} )

inherit autotools python-single-r1 xdg-utils

DESCRIPTION="Dropbox Nautilus Extension"
HOMEPAGE="https://github.com/dropbox/nautilus-dropbox"
SRC_URI="https://linux.dropboxstatic.com/packages/${P}.tar.bz2"

LICENSE="GPL-3 CC-BY-ND-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_MULTI_USEDEP}]' )
	dev-libs/glib:2
	gnome-base/nautilus
	net-misc/dropbox"

DEPEND="${RDEPEND}"

BDEPEND="
	$(python_gen_cond_dep 'dev-python/docutils[${PYTHON_MULTI_USEDEP}]' )
	virtual/pkgconfig"

# use system rst2man
PATCHES=( "${FILESDIR}/nautilus-dropbox-2019-system-rst2man.patch" )

src_prepare() {
	default

	# use system dropbox
	sed \
		-e "s|~/[.]dropbox-dist|${EPREFIX}/opt/dropbox|" \
		-e "s|\(DROPBOXD_PATH = \).*|\1\"${EPREFIX}/opt/dropbox/dropboxd\"|" \
		-i dropbox.in || die
	AT_NOELIBTOOLIZE=yes eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug) \
		--disable-static
}

src_install() {
	default

	# removes files which conflicts with system dropbox
	rm -r "${D}/usr/share/applications" || die
	rm -r "${D}/usr/bin" || die
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
