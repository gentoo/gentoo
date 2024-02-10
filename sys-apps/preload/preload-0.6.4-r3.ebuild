# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Adaptive readahead daemon"
HOMEPAGE="https://sourceforge.net/projects/preload/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="vanilla"

BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig
"
RDEPEND=">=dev-libs/glib-2.6:2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/00-patch-configure.diff
	"${FILESDIR}"/02-patch-preload_conf.diff
	"${FILESDIR}"/02-patch-preload_sysconfig.diff
	"${FILESDIR}"/${PN}-0.6.4-use-help2man-as-usual.patch
	"${FILESDIR}"/${PN}-0.6.4-use-make-dependencies.patch
)

src_prepare() {
	use vanilla || eapply "${FILESDIR}"/000{1,2,3}-*.patch
	default

	cat "${FILESDIR}"/preload-0.6.4.init.in-r2 > preload.init.in || die
	eautoreconf
}

src_configure() {
	econf --localstatedir=/var
}

src_install() {
	default

	# Remove log and state file from image or they will be
	# truncated during merge
	rm "${ED}"/var/lib/preload/preload.state || die "cleanup failed"
	rm "${ED}"/var/log/preload.log || die "cleanup failed"
	keepdir /var/lib/preload
	keepdir /var/log
}

pkg_postinst() {
	if [[ "$(rc-config list default | grep preload)" = "" ]] ; then
		elog "You probably want to add preload to the default runlevel like so:"
		elog "# rc-update add preload default"
	fi

	if has_version sys-fs/e4rat ; then
		elog "It appears you have sys-fs/e4rat installed. This may"
		elog "has negative effects on it. You may want to disable preload"
		elog "when using sys-fs/e4rat."
		elog "http://e4rat.sourceforge.net/wiki/index.php/Main_Page#Debian.2FUbuntu"
	fi
}
