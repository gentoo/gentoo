# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

OFED_VER="4.17-1"
OFED_RC="1"
OFED_RC_VER="2"
OFED_SUFFIX="0.2.gbd7e502"
OFED_SNAPSHOT="1"

inherit openib autotools

DESCRIPTION="InfiniBand userspace tools"
KEYWORDS="~amd64 ~x86 ~amd64-linux"
IUSE="static-libs"

RDEPEND="sys-fabric/rdma-core:=
	sys-fabric/opensm:${SLOT}
	dev-lang/tk:=
	media-gfx/graphviz[tcl]"
DEPEND="${RDEPEND}"

block_other_ofed_versions

PATCHES=(
	"${FILESDIR}"/01-fix-with_osm_libs.patch
	"${FILESDIR}"/02-fix-format-warning.patch
	"${FILESDIR}"/03-remove-rpath.patch
	"${FILESDIR}"/04-do_not_use_tmp.patch
	"${FILESDIR}"/05-makefile_dependencies.patch
)

src_prepare() {
	default

	for conf in configure.in */configure.in; do
		mv "${conf}" "${conf/.in/.ac}" || die
	done

	AT_M4DIR=config eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-tk-lib="${EPREFIX}/usr/$(get_libdir)"
		--with-ibdm="${S}/ibdm"
		--with-ibdm-lib="${EPREFIX}/usr/$(get_libdir)"
		--with-ibis="${EPREFIX}/usr/bin"
		--with-osm="${EPREFIX}/usr"
		--with-osm-libs="${EPREFIX}/usr/$(get_libdir)"
		$(use_enable static-libs static)
	)

	econf "${myeconfargs[@]}"
}
