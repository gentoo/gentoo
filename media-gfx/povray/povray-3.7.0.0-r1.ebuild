# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools flag-o-matic versionator virtualx

POVRAY_MAJOR_VER=$(get_version_component_range 1-3)
POVRAY_MINOR_VER=$(get_version_component_range 4)
if [ -n "$POVRAY_MINOR_VER" ]; then
	POVRAY_MINOR_VER=${POVRAY_MINOR_VER/rc/RC}
	MY_PV="${POVRAY_MAJOR_VER}.${POVRAY_MINOR_VER}"
else
	MY_PV=${POVRAY_MAJOR_VER}
fi

DESCRIPTION="The Persistence of Vision Raytracer"
HOMEPAGE="http://www.povray.org/"
SRC_URI="https://github.com/POV-Ray/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ~ia64 ~mips ppc ~ppc64 ~sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="debug +io-restrictions openexr static-libs tiff X"

DEPEND="
	>=dev-libs/boost-1.50.0:=[threads(+)]
	media-libs/libpng:0
	sys-libs/zlib
	virtual/jpeg:0
	openexr? (
		media-libs/ilmbase
		media-libs/openexr )
	tiff? ( media-libs/tiff:0 )
	X? ( media-libs/libsdl )"
RDEPEND="${DEPEND}"
DEPEND="${DEPEND}
	sys-devel/autoconf-archive"

S=${WORKDIR}/${PN}-${MY_PV}

PATCHES=(
	"${FILESDIR}"/${P}-user-conf.patch
	"${FILESDIR}"/${P}-automagic.patch
)

src_prepare() {
	[[ ${CHOST} == *-darwin* ]] && \
		PATCHES+=( "${FILESDIR}"/${PN}-3.7.0_rc6-darwin-defaults.patch )
	eapply "${FILESDIR}"/${PF}-boost-1.50.patch

	pushd unix &>/dev/null || die
		pushd config &>/dev/null || die
		rm -rf \
			acx_pthread.m4 \
			ax_boost_base.m4 \
			ax_boost_thread.m4 \
			ax_compare_version.m4 \
			ax_compiler_vendor.m4 \
			ax_compiler_version.m4 || die
		popd &>/dev/null || die
	bash -x prebuild.sh || die
	popd &>/dev/null || die

	rm -rf libraries || die

	# Change some destination directories that cannot be adjusted via configure
	sed \
		-e 's:${povsysconfdir}/$PACKAGE/$VERSION_BASE:${povsysconfdir}/'${PN}':g' \
		-e 's:${povdatadir}/$PACKAGE-$VERSION_BASE:${povdatadir}/'${PN}':g' \
		-e 's:${povdatadir}/doc/$PACKAGE-$VERSION_BASE:${povdatadir}/doc/'${PF}':g' \
		-e 's:BOOST_THREAD_LIBS $LIBS:BOOST_THREAD_LIBS $LIBS -lboost_date_time:g' \
		-i configure.ac || die

	sed \
		-e "s:^povlibdir = .*:povlibdir = @datadir@/${PN}:" \
		-e "s:^povdocdir = .*:povdocdir = @datadir@/doc/${PF}:" \
		-e "s:^povconfdir = .*:povconfdir = @sysconfdir@/${PN}:" \
		-e 's:mkdir_p:MKDIR_P:g' \
		-i Makefile.am || die

	# The "+p" option on the test command line causes a pause and
	# prompts the user to interact, so remove it.
	sed -i -e "s:biscuit.pov -f +d +p:biscuit.pov -f +d:" Makefile.am || die
	default

	eautoreconf
}

src_configure() {
	# Fixes bug 71255
	if [[ $(get-flag march) == k6-2 ]]; then
		filter-flags -fomit-frame-pointer
	fi

	# The config files are installed correctly (e.g. povray.conf),
	# but the code compiles using incorrect [default] paths
	# (based on /usr/local...), so povray will not find the system
	# config files without the following fix:
	append-cppflags -DPOVLIBDIR=\\\"${EROOT}usr/share/${PN}\\\" -DPOVCONFDIR=\\\"${EROOT}etc/${PN}\\\"

	econf \
		COMPILED_BY="Portage (Gentoo $(uname)) on $(hostname -f)" \
		$(use_enable debug) \
		$(use_enable io-restrictions) \
		$(use_with openexr openexr "${EPREFIX}/usr/$(get_libdir)") \
		$(use_with tiff libtiff "${EPREFIX}/usr/$(get_libdir)") \
		$(use_with X libsdl "${EPREFIX}/usr/$(get_libdir)") \
		$(use_with X x "${EPREFIX}/usr/$(get_libdir)") \
		$(use_enable static-libs static) \
		$(usex tiff "" "NON_REDISTRIBUTABLE_BUILD=yes") \
		--without-libmkl \
		--disable-pipe \
		--disable-strip \
		--disable-optimiz \
		--disable-optimiz-arch
}

src_test() {
	virtx default
}

pkg_preinst() {
	# Copy the old config files if they are in the old location
	# but do not yet exist in the new location.
	# This way, they can be treated by CONFIG_PROTECT as normal.
	local conf_file version_dir
	for conf_file in "${ED}"/etc/"${PN}"/*; do
		if [ ! -e "${EROOT}etc/${PN}/${conf_file}" ]; then
			for version_dir in $(echo "${EROOT}"etc/"${PN}"/* | grep "^[0-9]" | sort -rn); do
				if [ -e "${EROOT}etc/${PN}/${version_dir}/${conf_file}" ]; then
					mv "${EROOT}etc/${PN}/${version_dir}/${conf_file}" "${EROOT}etc/${PN}" || die
					elog "Note: ${conf_file} moved from ${EROOT}etc/povray/${version_dir}/ to ${EROOT}etc/povray/"
					break
				fi
			done
		fi
	done
}
