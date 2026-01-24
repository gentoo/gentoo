# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}-${PV/_/}"
inherit autotools flag-o-matic vala xdg

DESCRIPTION="Library for file management"
HOMEPAGE="https://wiki.lxde.org/en/PCManFM"
SRC_URI="https://github.com/lxde/libfm/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0/5.3.1" # copy ABI_VERSION because it seems upstream change it randomly
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~x86"
IUSE="+automount debug doc examples exif gtk udisks vala"

REQUIRED_USE="udisks? ( automount ) doc? ( gtk )"

DEPEND="
	>=dev-libs/glib-2.18:2
	>=lxde-base/menu-cache-1.1.0-r1:=
	~x11-libs/libfm-extra-${PV}
	gtk? ( x11-libs/gtk+:3 )
	udisks? ( dev-libs/dbus-glib )
"
RDEPEND="${DEPEND}
	!lxde-base/lxshortcut
	x11-misc/shared-mime-info
	automount? (
		udisks? ( gnome-base/gvfs[udev,udisks] )
		!udisks? ( gnome-base/gvfs[udev] )
	)
	exif? ( media-libs/libexif )
"
BDEPEND="
	app-arch/xz-utils
	dev-util/glib-utils
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )
	vala? ( $(vala_depend) )
"

PATCHES=(
	"${FILESDIR}/${P}-buildsystem.patch"
	"${FILESDIR}/${PN}-1.3.2-c99.patch"
)

src_prepare() {
	xdg_src_prepare

	if ! use doc; then
		sed -ie '/^SUBDIR.*=/s#docs##' Makefile.am || die
		sed -ie '/^[[:space:]]*docs/d' configure.ac || die
	fi

	# disable unused translations. Bug #356029
	cat <<-EOF >> po/POTFILES.in || die
data/ui/app-chooser.ui
data/ui/ask-rename.ui
data/ui/exec-file.ui
data/ui/file-prop.ui
data/ui/preferred-apps.ui
data/ui/progress.ui
EOF

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
	vala_setup
}

src_configure() {
	# bug #944077
	append-cflags -std=gnu17

	local myeconfargs=(
		--disable-static
		--with-html-dir=/usr/share/doc/${PF}/html
		$(use_enable debug)
		$(use_enable doc gtk-doc)
		$(use_enable examples demo)
		$(use_enable exif)
		$(use_with gtk gtk 3)
		$(use_enable udisks)
		$(use_enable vala old-actions)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	# Sometimes a directory is created instead of a symlink. No idea why...
	# It is wrong anyway. We expect a libfm-1.0 directory and then a libfm
	# symlink to it.
	if [[ -h ${D}/usr/include/${PN} || -d ${D}/usr/include/${PN} ]]; then
		rm -r "${D}"/usr/include/${PN} || die
	fi
	# Remove files installed by split-off libfm-extra package
	rm "${D}"/usr/include/libfm-1.0/fm-{extra,version,xml-file}.h || die
	rm "${D}"/usr/$(get_libdir)/libfm-extra* || die
	rm "${D}"/usr/$(get_libdir)/pkgconfig/libfm-extra.pc || die
}

pkg_preinst() {
	xdg_pkg_preinst
	# Resolve the symlink mess. Bug #439570
	if [[ -d "${ROOT}"/usr/include/${PN} ]]; then
		rm -rf "${ROOT}"/usr/include/${PN} || die
	fi
	if [[ -d "${D}"/usr/include/${PN}-1.0 ]]; then
		cd "${D}"/usr/include || die
		ln -s --force ${PN}-1.0 ${PN} || die
	fi
}
