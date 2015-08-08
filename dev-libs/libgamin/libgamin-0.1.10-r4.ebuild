# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
PYTHON_DEPEND="python? 2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"
GNOME_ORG_MODULE="gamin"
GNOME_TARBALL_SUFFIX="bz2"

inherit autotools eutils flag-o-matic libtool python gnome.org multilib-minimal

DESCRIPTION="Library providing the FAM File Alteration Monitor API"
HOMEPAGE="http://www.gnome.org/~veillard/gamin/"
SRC_URI="${SRC_URI}
	mirror://gentoo/gamin-0.1.9-freebsd.patch.bz2
	http://dev.gentoo.org/~grobian/patches/libgamin-0.1.10-opensolaris.patch.bz2
	http://pkgconfig.freedesktop.org/releases/pkg-config-0.26.tar.gz" # pkg.m4 for eautoreconf

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-solaris"
IUSE="debug kernel_linux python static-libs"

RESTRICT="test" # needs gam-server

RDEPEND="!app-admin/fam
	!<app-admin/gamin-0.1.10"
DEPEND="${RDEPEND}"

pkg_setup() {
	if use python; then
		python_pkg_setup
	fi
}

src_prepare() {
	mv -vf "${WORKDIR}"/pkg-config-*/pkg.m4 "${WORKDIR}"/ || die

	# Fix QA warnings, bug #257281, upstream #466791
	epatch "${FILESDIR}"/${PN}-0.1.10-compilewarnings.patch

	if [[ ${CHOST} != *-solaris* ]] ; then
		# Fix compile warnings; bug #188923
		epatch "${DISTDIR}"/gamin-0.1.9-freebsd.patch.bz2
	else
		# (Open)Solaris necessary patches (changes configure.in), unfortunately
		# conflicts with freebsd patch and breaks some linux installs so it must
		# only be applied if on solaris.
		epatch "${DISTDIR}"/${P}-opensolaris.patch.bz2
	fi

	# Fix collision problem due to intermediate library, upstream bug #530635
	epatch "${FILESDIR}"/${PN}-0.1.10-noinst-lib.patch

	# Fix compilation with latest glib, bug #382783
	epatch "${FILESDIR}/${PN}-0.1.10-G_CONST_RETURN-removal.patch"

	# Fix crosscompilation issues, bug #267604
	epatch "${FILESDIR}/${PN}-0.1.10-crosscompile-fix.patch"

	# Enable linux specific features on armel, upstream bug #588338
	epatch "${FILESDIR}/${P}-armel-features.patch"

	# Fix possible server deadlock in ih_sub_cancel, upstream bug #667230
	epatch "${FILESDIR}/${PN}-0.1.10-deadlock.patch"

	# Drop DEPRECATED flags
	sed -i -e 's:-DG_DISABLE_DEPRECATED:$(NULL):g' server/Makefile.am || die

	# Build only shared version of Python module.
	epatch "${FILESDIR}"/${PN}-0.1.10-disable_python_static_library.patch

	# Python bindings are built/installed manually.
	sed -e "/SUBDIRS += python/d" -i Makefile.am

	sed -i \
		-e 's:AM_CONFIG_HEADER:AC_CONFIG_HEADERS:' \
		-e 's:AM_PROG_CC_STDC:AC_PROG_CC:' \
		configure.in || die #466962

	# autoconf is required as the user-cflags patch modifies configure.in
	# however, elibtoolize is also required, so when the above patch is
	# removed, replace the following call with a call to elibtoolize
	AT_M4DIR="${WORKDIR}" eautoreconf

	use python && python_clean_py-compile_files
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static) \
		--disable-debug \
		--disable-server \
		$(use_enable kernel_linux inotify) \
		$(use_enable debug debug-api) \
		$(use_with python)
}

multilib_src_compile() {
	default

	if multilib_is_native_abi && use python; then
		python_copy_sources python

		building() {
			emake \
				PYTHON_INCLUDES="${EPREFIX}$(python_get_includedir)" \
				PYTHON_SITE_PACKAGES="${EPREFIX}$(python_get_sitedir)" \
				PYTHON_VERSION="$(python_get_version)"
		}
		S="${BUILD_DIR}" python_execute_function -s --source-dir python building
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use python; then
		installation() {
			emake \
				DESTDIR="${D}" \
				PYTHON_SITE_PACKAGES="${EPREFIX}$(python_get_sitedir)" \
				PYTHON_VERSION="$(python_get_version)" \
				install
		}
		S="${BUILD_DIR}" python_execute_function -s --source-dir python installation

		python_clean_installation_image
	fi
}

multilib_src_instal_all() {
	dodoc AUTHORS ChangeLog README TODO NEWS doc/*txt
	dohtml doc/*

	find "${D}" -name '*.la' -exec rm -f {} +
}

pkg_postinst() {
	if use python; then
		python_mod_optimize gamin.py
	fi
}

pkg_postrm() {
	if use python; then
		python_mod_cleanup gamin.py
	fi
}
