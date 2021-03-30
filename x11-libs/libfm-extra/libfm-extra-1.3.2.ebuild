# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="libfm"
MY_P="${MY_PN}-${PV/_/}"
inherit autotools xdg

DESCRIPTION="Library for file management"
HOMEPAGE="https://wiki.lxde.org/en/PCManFM"
SRC_URI="https://github.com/lxde/libfm/archive/${PV}.tar.gz -> ${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-2"
SLOT="0/5.3.1" # copy ABI_VERSION because it seems upstream change it randomly
KEYWORDS="~alpha amd64 arm arm64 ~mips ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=dev-libs/glib-2.18:2"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	dev-util/gtk-doc-am
	>=dev-util/intltool-0.40
	sys-devel/gettext
	virtual/pkgconfig
"

PATCHES=( "${FILESDIR}/${P}-buildsystem.patch" )

src_prepare() {
	xdg_src_prepare

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
}

src_configure() {
	econf \
		--disable-static \
		--with-extra-only
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	# Sometimes a directory is created instead of a symlink. No idea why...
	# It is wrong anyway. We expect a libfm-1.0 directory and then a libfm
	# symlink to it.
	if [[ -h ${D}/usr/include/${MY_PN} || -d ${D}/usr/include/${MY_PN} ]]; then
		rm -r "${D}"/usr/include/${MY_PN} || die
	fi
}

pkg_preinst() {
	xdg_pkg_preinst
	# Resolve the symlink mess. Bug #439570
	if [[ -d "${ROOT}"/usr/include/${MY_PN} ]]; then
		rm -rf "${ROOT}"/usr/include/${MY_PN} || die
	fi
	if [[ -d "${D}"/usr/include/${MY_PN}-1.0 ]]; then
		cd "${D}"/usr/include || die
		ln -s --force ${MY_PN}-1.0 ${MY_PN} || die
	fi
}
