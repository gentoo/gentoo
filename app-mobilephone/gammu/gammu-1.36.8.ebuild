# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils cmake-utils

DESCRIPTION="A tool to handle your cellular phone"
HOMEPAGE="http://wammu.eu/gammu/"
SRC_URI="http://dl.cihar.com/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth curl dbi debug irda mysql nls postgres usb"

# TODO: figure out a way to disable gudev
RDEPEND="dev-libs/glib:2=
	virtual/libgudev:=
	bluetooth? ( net-wireless/bluez:= )
	curl? ( net-misc/curl:= )
	dbi? ( >=dev-db/libdbi-0.8.3:= )
	mysql? ( virtual/mysql:= )
	postgres? ( dev-db/postgresql:=[server] )
	usb? ( virtual/libusb:1= )
	dev-util/dialog"
DEPEND="${RDEPEND}
	irda? ( virtual/os-headers )
	nls? ( sys-devel/gettext )"

# sys-devel/gettext is needed for creating .mo files
# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" af ar bg bn ca cs da de el en_GB es et fi fr gl he hu id it ko nl pl pt_BR ro ru sk sv sw tr zh_CN zh_TW"
IUSE="${IUSE} ${MY_AVAILABLE_LINGUAS// / linguas_}"

src_prepare() {
	epatch "${FILESDIR}/${PN}-skip-locktest.patch" \
		"${FILESDIR}/${PN}-1.36.8-bashcompdir.patch"

	local lang support_linguas=no
	for lang in ${MY_AVAILABLE_LINGUAS} ; do
		if use linguas_${lang} ; then
			support_linguas=yes
			break
		fi
	done
	# install all languages when all selected LINGUAS aren't supported
	if [ "${support_linguas}" = "yes" ]; then
		for lang in ${MY_AVAILABLE_LINGUAS} ; do
			if ! use linguas_${lang} ; then
				rm -rf locale/${lang} || die
			fi
		done
	fi
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
