# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

README_GENTOO_SUFFIX="-r1"

inherit autotools eutils multilib readme.gentoo-r1 java-pkg-2 xdg-utils

DESCRIPTION="FOSS Java browser plugin and Web Start implementation"
HOMEPAGE="http://icedtea.classpath.org"
SRC_URI="http://icedtea.classpath.org/download/source/${P}.tar.gz"
LICENSE="GPL-2 GPL-2-with-linking-exception LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc64 ~x86"
IUSE="doc javascript nsplugin tagsoup test"
RESTRICT="test"

CDEPEND="javascript? ( dev-java/rhino:1.6 )
	nsplugin? ( >=dev-libs/glib-2.16:2= )
	tagsoup? ( dev-java/tagsoup:0 )"

DEPEND="${CDEPEND}
	app-arch/zip
	>=virtual/jdk-1.7
	virtual/pkgconfig
	nsplugin? ( net-misc/npapi-sdk )
	test? (	>=dev-java/junit-4.8:4 )"

RDEPEND="${CDEPEND}
	>=app-eselect/eselect-java-0.2.0
	>=virtual/jre-1.7
	nsplugin? (
		!dev-java/oracle-jdk-bin[nsplugin]
		!dev-java/oracle-jre-bin[nsplugin]
	)"

src_prepare() {
	# http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=2779
	# http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=2780
	# http://icedtea.classpath.org/bugzilla/show_bug.cgi?id=2855
	epatch "${FILESDIR}"/${PN}-1.6-{javadoc,no-hg,launchers,respect-ldflags,unused-libs}.patch

	if java-pkg_is-vm-version-ge "1.8" ; then
		sed -i 's/JAVADOC_OPTS=/\0-Xdoclint:none /g' Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	local tagsoup
	use tagsoup && tagsoup="$(java-pkg_getjars tagsoup)"

	local config=(
		# Rename javaws to itweb-javaws as eselect java-vm manages
		# javaws to prevent a clash with Oracle's implementation.
		--program-transform-name='s/^javaws$/itweb-javaws/'
		--libdir="${EPREFIX}"/usr/$(get_libdir)/nsbrowser/plugins
		--with-java="${EPREFIX}"/usr/bin/java
		--with-jdk-home="${JAVA_HOME}"
		$(use_enable doc docs)
		$(use_enable nsplugin plugin)
		$(use_with javascript rhino)
		$(use_with tagsoup tagsoup "${tagsoup}")
	)

	# See bug #573060.
	xdg_environment_reset

	# Rely on the --with-jdk-home option given above.
	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	econf "${config[@]}"
}

src_compile() {
	default
}

src_install() {
	default
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
