# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND="python? 2"

inherit eutils cmake-utils python

DESCRIPTION="A tool to handle your cellular phone"
HOMEPAGE="http://www.wammu.eu/"
SRC_URI="http://dl.cihar.com/${PN}/releases/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="bash-completion bluetooth curl dbi debug irda mysql nls postgres python usb"

RDEPEND="bluetooth? ( net-wireless/bluez )
	curl? ( net-misc/curl )
	usb? ( virtual/libusb:1 )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql[server] )
	dbi? ( >=dev-db/libdbi-0.8.3 )
	dev-util/dialog"
DEPEND="${RDEPEND}
	irda? ( virtual/os-headers )
	nls? ( sys-devel/gettext )"

# sys-devel/gettext is needed for creating .mo files
# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" af ar bg ca cs da de el en_GB es et fi fr gl he hu id it ko nl pl pt_BR ru sk sv sw tr zh_CN zh_TW"
IUSE="${IUSE} ${MY_AVAILABLE_LINGUAS// / linguas_}"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-skip-locktest.patch"
	epatch "${FILESDIR}/${PN}-1.32.0-bashcompdir.patch"

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
		$(cmake-utils_use_with bluetooth Bluez) \
		$(cmake-utils_use_with irda IRDA) \
		$(cmake-utils_use_with curl CURL) \
		$(cmake-utils_use_with usb USB) \
		$(cmake-utils_use_with python PYTHON) \
		$(cmake-utils_use_with mysql MySQL) \
		$(cmake-utils_use_with postgres Postgres) \
		$(cmake-utils_use_with dbi LibDBI) \
		$(cmake-utils_use_with nls GettextLibs) \
		$(cmake-utils_use_with nls Iconv) \
		-DBUILD_SHARED_LIBS=ON \
		-DINSTALL_DOC_DIR="share/doc/${PF}"
	)
	if ! use bash-completion; then
		mycmakeargs+=( -DINSTALL_BASH_COMPLETION=OFF )
	fi
	if use python; then
		mycmakeargs+=( -DBUILD_PYTHON="$(PYTHON -a)" )
	fi
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_test() {
	LD_LIBRARY_PATH="${WORKDIR}/${PN}_build/common" cmake-utils_src_test
}

src_install() {
	cmake-utils_src_install
}

pkg_postinst() {
	use python && python_mod_optimize gammu
}

pkg_postrm() {
	use python && python_mod_cleanup gammu
}
