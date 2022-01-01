# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools systemd bash-completion-r1

DESCRIPTION="Command-line program for btrfs and lvm snapshot management"
HOMEPAGE="http://snapper.io/"
SRC_URI="https://github.com/openSUSE/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc lvm pam test systemd xattr"
RESTRICT="test"

RDEPEND="dev-libs/boost:=[threads(+)]
	dev-libs/json-c:=
	dev-libs/libxml2
	dev-libs/icu:=
	sys-apps/acl
	sys-apps/dbus
	sys-apps/util-linux
	>=sys-fs/btrfs-progs-3.17.1
	sys-libs/zlib
	virtual/libintl
	lvm? ( sys-fs/lvm2 )
	pam? ( sys-libs/pam )
	xattr? ( sys-apps/attr )"

DEPEND="${RDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/cron-confd.patch
	"${FILESDIR}"/${P}-testsuite.patch
)

src_prepare() {
	default

	sed -e "s,/usr/lib/systemd/system,$(systemd_get_systemunitdir),g" \
		-i data/Makefile.* \
		|| die "Failed to fix systemd services and timers installation path"
	eautoreconf
}

src_configure() {
	# ext4 code does not work anymore
	# snapper does not build without btrfs
	local myeconfargs=(
		--disable-silent-rules
		--with-conf="/etc/conf.d"
		--enable-zypp
		--enable-rollback
		--enable-btrfs-quota
		--disable-ext4
		--enable-btrfs
		$(use_enable doc)
		$(use_enable lvm)
		$(use_enable pam)
		$(use_enable test tests)
		$(use_enable systemd)
		$(use_enable xattr xattrs)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default
	# Existing configuration file required to function
	keepdir /etc/snapper/configs
	newconfd data/sysconfig.snapper snapper
	find "${D}" -name '*.la' -delete || die
	newbashcomp "${FILESDIR}"/${PN}.bash ${PN}
}

pkg_postinst() {
	elog "In order to use Snapper, you need to set up"
	elog "at least one config first. To do this, run:"
	elog "snapper create-config <subvolume>"
	elog "For more information, see man (8) snapper or"
	elog "http://snapper.io/documentation.html"
}
