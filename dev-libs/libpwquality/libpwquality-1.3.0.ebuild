# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit eutils multilib pam python-r1 toolchain-funcs

DESCRIPTION="Library for password quality checking and generating random passwords"
HOMEPAGE="https://fedorahosted.org/libpwquality/"
SRC_URI="https://fedorahosted.org/releases/l/i/${PN}/${P}.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="pam python static-libs"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	>=sys-libs/cracklib-2.8:=[static-libs(+)?]
	pam? ( virtual/pam )
	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	>=sys-devel/gettext-0.18.2
	virtual/pkgconfig
"

src_prepare() {
	default
	# ensure pkgconfig files go in /usr
	sed -e 's:\(pkgconfigdir *=\).*:\1 '${EPREFIX}/usr/$(get_libdir)'/pkgconfig:' \
		-i src/Makefile.{am,in} || die "sed failed"
	use python && python_copy_sources
}

src_configure() {
	# Install library in /lib for pam
	configuring() {
		local sitedir
		econf \
			--libdir="${EPREFIX}/$(get_libdir)" \
			$(use_enable pam) \
			--with-securedir="${EPREFIX}/$(getpam_mod_dir)" \
			$(use_enable python python-bindings) \
			$(usex python "--with-pythonsitedir=$(use python && python_get_sitedir)" "") \
			$(use_enable static-libs static)
	}
	if_use_python_python_foreach_impl configuring
}

src_compile() {
	if_use_python_python_foreach_impl default
}

src_test() {
	if_use_python_python_foreach_impl default
}

src_install() {
	if_use_python_python_foreach_impl default
	if use static-libs; then
		# Do not install static libs in /lib
		mkdir -p "${ED}usr/$(get_libdir)"
		mv "${ED}$(get_libdir)/libpwquality.a" "${ED}/usr/$(get_libdir)/" || die
		gen_usr_ldscript libpwquality.so
	fi
	prune_libtool_files --modules
}

if_use_python_python_foreach_impl() {
	if use python; then
		python_foreach_impl run_in_build_dir "$@"
	else
		"$@"
	fi
}
