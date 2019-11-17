# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils flag-o-matic autotools vcs-snapshot

DESCRIPTION="An Portable Open Source UPnP Development Kit"
HOMEPAGE="http://pupnp.sourceforge.net/"
SRC_URI="https://github.com/mrjimenez/pupnp/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="1.8"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="blocking-tcp debug doc ipv6 +reuseaddr samples static-libs"

DOCS="ChangeLog"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.21-cflags.patch
)

src_prepare() {
	default

	# fix tests
	chmod +x ixml/test/test_document.sh || die

	eautoreconf
}

src_configure() {
	use x86-fbsd &&	append-flags -O1
	# w/o docdir to avoid sandbox violations
	econf $(use_enable debug) \
		$(use_enable blocking-tcp blocking-tcp-connections) \
		$(use_enable ipv6) \
		$(use_enable reuseaddr) \
		$(use_enable static-libs static) \
		$(use_enable samples)
}

src_install () {
	default

	use static-libs || prune_libtool_files

	# Slot samples
	if $(use samples); then
		for bin in combo ctrlpt device ; do
			newbin "upnp/sample/.libs/tv_$bin" "tv_$bin-${SLOT}"
		done
	fi

	# Slot includes
	cd "${D}/usr/include" || die
	mv upnp "upnp-${SLOT}" || die

	# Slot pkgconfig
	cd "${D}/usr/$(get_libdir)/pkgconfig" || die
	mv libupnp.pc "libupnp-${SLOT}.pc" || die
	sed -i -e "s#/upnp#/upnp-${SLOT}#" \
		-e "s#lupnp#lupnp-${SLOT}#" \
		-e "s#lixml#lixml-${SLOT}#" "libupnp-${SLOT}.pc" || die

	# Slot symlinks
	cd "${D}/usr/$(get_libdir)" || die
	mv libupnp.so "libupnp-${SLOT}.so" || die
	mv libixml.so "libixml-${SLOT}.so" || die
}
