# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools pam systemd

DESCRIPTION="D-Bus service to access fingerprint readers"
HOMEPAGE="https://fprint.freedesktop.org"
MY_PV="V_$(ver_rs 0- _)"
SRC_URI="https://gitlab.freedesktop.org/libfprint/${PN}/-/archive/${MY_PV}/fprintd-${MY_PV}.tar.bz2 -> ${P}.tar.bz2"
#SRC_URI="https://cgit.freedesktop.org/libfprint/${PN}/snapshot/${MY_PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc pam static-libs systemd"

RDEPEND="
	dev-libs/dbus-glib
	dev-libs/glib:2
	<sys-auth/libfprint-1.90.0
	sys-auth/polkit
	pam? ( sys-libs/pam )
"
DEPEND="${RDEPEND}
	dev-util/gtk-doc
	dev-util/gtk-doc-am
	dev-util/intltool
	doc? ( dev-libs/libxml2 dev-libs/libxslt )
"

S=${WORKDIR}/${MY_PV}

PATCHES=(
	"${FILESDIR}"/${PV}-configure_ac_systemd.patch
)

src_prepare() {
	default

	sed -i 's#@localstatedir@/lib/fprint#@localstatedir@/fprint#g' data/fprintd.service.in || die "sed failed"
	eautoreconf
}

src_configure() {
	local myeconfargs=( )
	if use systemd; then
		myeconfargs+=(
			--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
		)
	fi
	econf --disable-silent-rules \
		$(use_enable pam) \
		$(use_enable static-libs static) \
		$(use_enable doc gtk-doc-html) \
		$(use_enable systemd) \
		"${myeconfargs[@]}"
}

src_install() {
	emake DESTDIR="${D}" install \
		pammoddir=$(getpam_mod_dir)

	keepdir /var/lib/fprint

	find "${D}" -name "*.la" -delete || die

	dodoc AUTHORS NEWS README{,.transifex} TODO
	newdoc pam/README README.pam_fprintd
	if use doc ; then
		docinto html
		dodoc doc/{fprintd-docs,version}.xml
		docinto html/dbus
		dodoc doc/dbus/net.reactivated.Fprint.{Device,Manager}.ref.xml
	fi
}

pkg_postinst() {
	elog "Please take a look at README.pam_fprintd for integration docs."
}
