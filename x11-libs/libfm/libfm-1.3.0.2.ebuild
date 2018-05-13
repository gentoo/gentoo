# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools vala xdg-utils

DESCRIPTION="A library for file management"
HOMEPAGE="https://wiki.lxde.org/en/PCManFM"
SRC_URI="mirror://sourceforge/pcmanfm/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0/5.1.1" #copy ABI_VERSION because it seems upstream change it randomly
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="+automount debug doc examples exif gtk udisks +vala"

COMMON_DEPEND=">=dev-libs/glib-2.18:2
	gtk? ( >=x11-libs/gtk+-2.16:2 )
	>=lxde-base/menu-cache-0.3.2:=
	udisks? ( dev-libs/dbus-glib )"
RDEPEND="${COMMON_DEPEND}
	!lxde-base/lxshortcut
	x11-misc/shared-mime-info
	automount? (
		udisks? ( gnome-base/gvfs[udev,udisks] )
		!udisks? ( gnome-base/gvfs[udev] )
	)
	exif? ( media-libs/libexif )"
DEPEND="${COMMON_DEPEND}
	vala? ( $(vala_depend) )
	doc? (
		dev-util/gtk-doc
	)
	app-arch/xz-utils
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	sys-devel/gettext"

REQUIRED_USE="udisks? ( automount ) doc? ( gtk )"

src_prepare() {
	default

	if ! use doc; then
		sed -ie '/^SUBDIR.*=/s#docs##' "${S}"/Makefile.am || die "sed failed"
		sed -ie '/^[[:space:]]*docs/d' configure.ac || die "sed failed"
	fi
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
	vala_src_prepare
}

src_configure() {
	econf \
		--sysconfdir="${EPREFIX}/etc" \
		--disable-dependency-tracking \
		--disable-static \
		$(use_enable examples demo) \
		$(use_enable exif) \
		$(use_enable debug) \
		$(use_enable udisks) \
		$(use_enable vala actions) \
		$(use_with gtk) \
		$(use_enable doc gtk-doc)
}

src_install() {
	default
	find "${D}" -name '*.la' -exec rm -f '{}' +
	# Sometimes a directory is created instead of a symlink. No idea why...
	# It is wrong anyway. We expect a libfm-1.0 directory and then a libfm
	# symlink to it.
	if [[ -h ${D}/usr/include/${PN} || -d ${D}/usr/include/${PN} ]]; then
		rm -r "${D}"/usr/include/${PN}
	fi
}

pkg_preinst() {
	# Resolve the symlink mess. Bug #439570
	[[ -d "${ROOT}"/usr/include/${PN} ]] && \
		rm -rf "${ROOT}"/usr/include/${PN}
	if [[ -d "${D}"/usr/include/${PN}-1.0 ]]; then
		cd "${D}"/usr/include
		ln -s --force ${PN}-1.0 ${PN}
	fi
}

pkg_postinst() {
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
}
