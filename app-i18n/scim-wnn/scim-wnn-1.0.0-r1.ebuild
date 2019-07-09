# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Japanese input method Wnn IMEngine for SCIM"
HOMEPAGE="http://nop.net-p.org/modules/pukiwiki/index.php?%5B%5Bscim-wnn%5D%5D"
SRC_URI="http://nop.net-p.org/files/scim-wnn/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE="+freewnn"

RDEPEND=">=app-i18n/scim-1.4[-gtk3]
	dev-libs/wnn7sdk
	freewnn? ( app-i18n/freewnn )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	# bug #295733
	"${FILESDIR}/${P}-gcc43.patch"
)

src_prepare() {
	default
	# bug #140794
	sed -i -e 's:$LDFLAGS conftest.$ac_ext $LIBS:conftest.$ac_ext $LIBS $LDFLAGS:g' \
		configure || die "ldflags sed failed"

#	sed -i -e "s:/usr/lib/wnn7:/usr/$(get_libdir)/wnn:g" \
	sed -i -e "s:/usr/lib/wnn7:/usr/lib/wnn:g" \
		src/scim_wnn_def.h src/wnnconversion.cpp || die "sed failed"
}

pkg_postinst() {
	elog
	elog "To use SCIM with both GTK2 and XIM, you should use the following"
	elog "in your user startup scripts such as .gnomerc or .xinitrc:"
	elog
	elog "LANG='your_language' scim -d"
	elog "export XMODIFIERS=@im=SCIM"
	elog
	if ! use freewnn ; then
	ewarn
	ewarn "You disabled freewnn USE flag."
	ewarn "Please make sure you have wnnenvrc visible to scim-wnn."
	ewarn
	fi
}
