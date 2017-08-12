# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="A tool to handle your cellular phone"
HOMEPAGE="http://wammu.eu/gammu/"
SRC_URI="http://dl.cihar.com/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bluetooth curl dbi debug irda mysql nls postgres usb odbc"

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
	odbc? ( dev-db/unixODBC )
	nls? ( sys-devel/gettext )
"
RDEPEND="
	${COMMON_DEPEND}
	dev-util/dialog
	virtual/libiconv
"

# sys-devel/gettext is needed for creating .mo files
# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" af ar bg bn ca cs da de el en_GB es et fi fr gl he hu id it ko nl pl pt_BR ro ru sk sv sw tr zh_CN zh_TW"
IUSE="${IUSE} ${MY_AVAILABLE_LINGUAS// / linguas_}"

src_prepare() {
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
	eapply_user
}

src_configure() {
	# debug flag is used inside cmake-utils.eclass
	local mycmakeargs=(
		-DWITH_BLUETOOTH=$(usex bluetooth)
		-DWITH_IRDA=$(usex irda)
		-DWITH_CURL=$(usex curl)
		-DWITH_USB=$(usex usb)
		-DWITH_MySQL=$(usex mysql)
		-DWITH_Postgres=$(usex postgres)
		-DWITH_LibDBI=$(usex dbi)
		-DWITH_Gettext=$(usex nls)
		-DWITH_Iconv=$(usex nls)
		-DWITH_ODBC=$(usex odbc)
		-DBUILD_SHARED_LIBS=ON
		-DINSTALL_DOC_DIR="share/doc/${PF}"
	)
	cmake-utils_src_configure
}

src_test() {
	LD_LIBRARY_PATH="${WORKDIR}/${PN}_build/common" cmake-utils_src_test
}
