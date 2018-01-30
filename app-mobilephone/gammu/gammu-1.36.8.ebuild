# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="A tool to handle your cellular phone"
HOMEPAGE="https://wammu.eu/gammu/"
SRC_URI="http://dl.cihar.com/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth curl dbi debug irda mysql nls postgres usb"

COMMON_DEPEND="
	dev-libs/glib:2=
	virtual/libgudev:=
	bluetooth? ( net-wireless/bluez:= )
	curl? ( net-misc/curl:= )
	dbi? ( >=dev-db/libdbi-0.8.3:= )
	mysql? ( virtual/mysql:= )
	postgres? ( dev-db/postgresql:= )
	usb? ( virtual/libusb:1= )
"
DEPEND="
	${COMMON_DEPEND}
	irda? ( virtual/os-headers )
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${COMMON_DEPEND}
	dev-util/dialog
"

# sys-devel/gettext is needed for creating .mo files
# Supported languages and translated documentation
MY_AVAILABLE_LINGUAS=" af ar bg bn ca cs da de el en_GB es et fi fr gl he hu id it ko nl pl pt_BR ro ru sk sv sw tr zh_CN zh_TW"

PATCHES=(
	"${FILESDIR}/${PN}-skip-locktest.patch"
	"${FILESDIR}/${PN}-1.36.8-bashcompdir.patch"
)

src_prepare() {
	cmake-utils_src_prepare

	local lang
	for lang in ${MY_AVAILABLE_LINGUAS} ; do
		if ! has ${lang} ${LINGUAS-${lang}} ; then
			rm -rf locale/${lang} || die
		fi
	done
}

src_configure() {
	# debug flag is used inside cmake-utils.eclass
	local mycmakeargs=(
		$(cmake-utils_use_with bluetooth Bluez)
		$(cmake-utils_use_with irda IRDA)
		$(cmake-utils_use_with curl CURL)
		$(cmake-utils_use_with usb USB)
		$(cmake-utils_use_with mysql MySQL)
		$(cmake-utils_use_with postgres Postgres)
		$(cmake-utils_use_with dbi LibDBI)
		$(cmake-utils_use_with nls GettextLibs)
		$(cmake-utils_use_with nls Iconv)
		-DBUILD_SHARED_LIBS=ON
		-DINSTALL_DOC_DIR="share/doc/${PF}"
	)
	cmake-utils_src_configure
}

src_test() {
	LD_LIBRARY_PATH="${WORKDIR}/${PN}_build/common" cmake-utils_src_test
}
