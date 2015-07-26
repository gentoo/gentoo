# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libfm-extra/libfm-extra-1.2.3.ebuild,v 1.5 2015/07/23 19:56:02 pacho Exp $

EAPI=5
inherit autotools fdo-mime

MY_PV=${PV/_/}
MY_PN="libfm"
MY_P="${MY_PN}-${MY_PV}"
DESCRIPTION="A library for file management"
HOMEPAGE="http://pcmanfm.sourceforge.net/"
SRC_URI="http://dev.gentoo.org/~hwoarang/distfiles/${MY_P}.tar.xz"

KEYWORDS="~alpha ~amd64 arm ~arm64 ~mips ppc ~x86 ~amd64-linux ~x86-linux"
LICENSE="GPL-2"
SLOT="0/4.3.0" #copy ABI_VERSION because it seems upstream change it randomly
IUSE=""

RDEPEND=">=dev-libs/glib-2.18:2"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext
	!!<=x11-libs/libfm-1.2.3"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	sed -ie '/^SUBDIR.*=/s#docs##' "${S}"/Makefile.am || die "sed failed"
	sed -ie '/^[[:space:]]*docs/d' configure.ac || die "sed failed"
	sed -i -e "s:-O0::" -e "/-DG_ENABLE_DEBUG/s: -g::" \
		configure.ac || die "sed failed"

	#disable unused translations. Bug #356029
	for trans in app-chooser ask-rename exec-file file-prop preferred-apps \
		progress;do
		echo "data/ui/"${trans}.ui >> po/POTFILES.in
	done
	#Remove -Werror for automake-1.12. Bug #421101
	sed -i "s:-Werror::" configure.ac || die

	# subslot sanity check
	local sub_slot=${SLOT#*/}
	local libfm_major_abi=$(sed -rne '/ABI_VERSION/s:.*=::p' src/Makefile.am | tr ':' '.')

	if [[ ${sub_slot} != ${libfm_major_abi} ]]; then
		eerror "Ebuild sub-slot (${sub_slot}) does not match ABI_VERSION(${libfm_major_abi})"
		eerror "Please update SLOT variable as follows:"
		eerror "    SLOT=\"${SLOT%%/*}/${libfm_major_abi}\""
		eerror
		die "sub-slot sanity check failed"
	fi

	eautoreconf
	rm -r autom4te.cache || die
}

src_configure() {
	econf --sysconfdir="${EPREFIX}/etc" --disable-dependency-tracking \
		--disable-static --with-extra-only
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f '{}' +
	# Sometimes a directory is created instead of a symlink. No idea why...
	# It is wrong anyway. We expect a libfm-1.0 directory and then a libfm
	# symlink to it.
	if [[ -h ${D}/usr/include/${MY_PN} || -d ${D}/usr/include/${MY_PN} ]]; then
		rm -r "${D}"/usr/include/${MY_PN}
	fi
}

pkg_preinst() {
	# Resolve the symlink mess. Bug #439570
	[[ -d "${ROOT}"/usr/include/${MY_PN} ]] && \
		rm -rf "${ROOT}"/usr/include/${MY_PN}
	if [[ -d "${D}"/usr/include/${MY_PN}-1.0 ]]; then
		cd "${D}"/usr/include
		ln -s --force ${MY_PN}-1.0 ${MY_PN}
	fi
}

pkg_postinst() {
	fdo-mime_mime_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
