# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Scanner Access Now Easy"
HOMEPAGE="http://www.sane-project.org"
SRC_URI="https://salsa.debian.org/debian/sane-frontends/-/archive/upstream/${PV}/${PN}-upstream-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="gimp gtk"

RDEPEND="
	media-gfx/sane-backends
	gimp? ( media-gfx/gimp:2 )
	gtk? (
		dev-libs/glib:2
		x11-libs/gtk+:2
	)
"
DEPEND="${RDEPEND}"

REQUIRED_USE="gimp? ( gtk )"

DOCS=( AUTHORS Changelog NEWS PROBLEMS README )

PATCHES=( "${FILESDIR}/MissingCapsFlag.patch" )

S="${WORKDIR}"/"${PN}"-upstream-"${PV}"

src_configure() {
	econf \
		--datadir=/usr/share/misc \
		$(use_enable gimp) \
		$(use_enable gtk gtk2) \
		$(use_enable gtk guis)
}

src_install() {
	local gimpplugindir
	local gimptool
	emake DESTDIR="${D}" install

	# link xscanimage so it is seen as a plugin in gimp
	if use gimp; then
		local plugindir
		if [ -x "${EPREFIX}"/usr/bin/gimptool ]; then
			plugindir="$(gimptool --gimpplugindir)/plug-ins"
		elif [ -x "${EPREFIX}"/usr/bin/gimptool-2.0 ]; then
			plugindir="$(gimptool-2.0 --gimpplugindir)/plug-ins"
		else
			die "Can't find GIMP plugin directory."
		fi
		dodir "${plugindir#${EPREFIX}}"
		dosym "${EPREFIX}"/usr/bin/xscanimage "${plugindir#${EPREFIX}}"/xscanimage
	fi

	einstalldocs
}
