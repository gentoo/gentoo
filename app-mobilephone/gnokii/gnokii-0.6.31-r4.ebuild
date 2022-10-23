# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools desktop linux-info strip-linguas

HOMEPAGE="https://www.gnokii.org/"
if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="
		git://git.savannah.nongnu.org/${PN}.git
		http://git.savannah.gnu.org/r/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://www.gnokii.org/download/${PN}/${P}.tar.bz2"
	KEYWORDS="amd64 ~hppa ~ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi
DESCRIPTION="User space driver and tools for use with mobile phones"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth debug ical irda mysql nls +pcsc-lite postgres sms usb X"

RDEPEND="
	!app-mobilephone/smstools
	dev-libs/glib:2
	bluetooth? ( kernel_linux? ( net-wireless/bluez ) )
	ical? ( dev-libs/libical:= )
	pcsc-lite? ( sys-apps/pcsc-lite )
	sms? (
		postgres? ( dev-db/postgresql:* )
		mysql? ( dev-db/mysql-connector-c:= )
	)
	usb? ( virtual/libusb:0 )
	X? ( x11-libs/gtk+:2 )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	irda? ( virtual/os-headers )
	nls? ( sys-devel/gettext )
"

CONFIG_CHECK="~UNIX98_PTYS"

S="${WORKDIR}/${PN}-${PV%.1}"

# Supported languages and translated documentation
# Be sure all languages are prefixed with a single space!
MY_AVAILABLE_LINGUAS=" cs de et fi fr it nl pl pt sk sl sv zh_CN"

PATCHES=(
	"${FILESDIR}"/${P}-docdir.patch
	"${FILESDIR}"/${P}-fix_xgnokii_inclusion.patch
	"${FILESDIR}"/${P}-gcc5.patch
	"${FILESDIR}"/${P}-gcc7.patch
	"${FILESDIR}"/${PN}-0.6.31-sqlite-typo.patch
)

src_prepare() {
	[[ ${PV} == *9999 ]] && \
		PATCHES=(
			"${FILESDIR}"/${P}-icon.patch
			"${FILESDIR}"/${P}-translations.patch
		)

	default

	sed -i -e "s:/usr/local:${EPREFIX}/usr:" Docs/sample/gnokiirc || die

	# bug 775485
	sed -i -e "s:my_bool:bool:" smsd/mysql.c || die

	cp "${FILESDIR}"/${P}-codeset.m4 m4/codeset.m4 || die
	mv configure.{in,ac} || die

	eautoreconf
}

src_configure() {
	strip-linguas ${MY_AVAILABLE_LINGUAS}

	local config_xdebug
	if use X && use debug; then
		config_xdebug="--enable-xdebug"
	else
		config_xdebug="--disable-xdebug"
	fi

	econf \
		--disable-static \
		--enable-security \
		--disable-unix98test \
		$(use_enable bluetooth) \
		${config_xdebug} \
		$(use_enable debug fulldebug) \
		$(use_enable debug rlpdebug) \
		$(use_enable ical libical) \
		$(use_enable irda) \
		$(use_enable mysql) \
		$(use_enable nls) \
		$(use_enable pcsc-lite libpcsclite) \
		$(use_enable postgres) \
		$(use_enable sms smsd) \
		$(use_enable usb libusb) \
		$(use_with X x)
}

src_test() {
	echo common/phones/fake.c >> po/POTFILES.in || die
	default
}

src_install() {
	default

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die

	insinto /etc
	doins Docs/sample/gnokiirc

	# only one file needs suid root to make a pseudo device
	fperms 4755 /usr/sbin/mgnokiidev

	use X && newicon Docs/sample/logo/gnokii.xpm xgnokii.xpm

	if use sms; then
		cd smsd || die

		docinto smsd
		use mysql && dodoc sms.tables.mysql.sql README.MySQL
		use postgres && dodoc sms.tables.pq.sql
		dodoc README ChangeLog README.Tru64 action
	fi
}

pkg_postinst() {
	elog "Make sure the user that runs gnokii has read/write access to the device"
	elog "which your phone is connected to."
	elog "The simple way of doing that is to add your user to the uucp group."
	if [[ ${PV} == *9999 ]]; then
		elog "This is the GIT version of ${PN}. It is experimental but may have important bug fixes."
		elog "You can keep track of the most recent commits at:"
		elog "    http://git.savannah.gnu.org/cgit/gnokii.git/"
		elog "Whenever there is a change you are interested in, you can re-emerge ${P}."
	fi
}
