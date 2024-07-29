# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Real-time satellite tracking and orbit prediction application"
HOMEPAGE="http://gpredict.oz9aec.net"

if [[ ${PV} = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/csete/gpredict.git"
else
	COMMIT="098e3768240c7f5a169930a2660a23c9f42b37d6"
	SRC_URI="https://github.com/csete/gpredict/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"
	KEYWORDS="~amd64 ~ppc ~x86"
fi

LICENSE="GPL-2"
SLOT="0"

RDEPEND="dev-libs/glib:2
	x11-libs/gdk-pixbuf[jpeg]
	x11-libs/gtk+:3
	x11-libs/goocanvas:2.0
	net-misc/curl"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

DOCS=( AUTHORS NEWS README )

PATCHES=(
	# remove wrong doc location
	"${FILESDIR}/${PN}-2.3-doc.patch"
	"${FILESDIR}/${PN}-2.3-gethostbyname.patch"
)

src_prepare() {
	default
	# prepare Version info
	if [[ ${PV} != "9999" ]]; then
		echo "${PV}" > "${S}"/.tarball-version
	fi
	eautoreconf
}
