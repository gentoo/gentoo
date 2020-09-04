# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

README_GENTOO_SUFFIX="-r1"
CRATES="dunce-0.1.1"

inherit autotools eutils multilib readme.gentoo-r1 java-pkg-2 cargo xdg-utils

DESCRIPTION="FOSS Java browser plugin and Web Start implementation"
HOMEPAGE="http://icedtea.classpath.org"
SRC_URI="https://github.com/AdoptOpenJDK/${PN}/archive/${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
LICENSE="GPL-2 GPL-2-with-linking-exception LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE="doc javascript nsplugin tagsoup test"
RESTRICT="test"

CDEPEND="javascript? ( dev-java/rhino:1.6 )
	nsplugin? ( >=dev-libs/glib-2.16:2= )
	tagsoup? ( dev-java/tagsoup:0 )"

DEPEND="${CDEPEND}
	app-arch/zip
	>=virtual/jdk-1.7
	virtual/pkgconfig
	virtual/rust
	nsplugin? ( net-misc/npapi-sdk )
	test? (	>=dev-java/junit-4.8:4 )"

RDEPEND="${CDEPEND}
	>=app-eselect/eselect-java-0.2.0
	>=virtual/jre-1.7
	nsplugin? (
		!dev-java/oracle-jdk-bin[nsplugin]
		!dev-java/oracle-jre-bin[nsplugin]
	)"

S="${WORKDIR}/IcedTea-Web-${P}"

src_prepare() {
	eapply_user

	if java-pkg_is-vm-version-ge "1.8" ; then
		sed -i 's/JAVADOC_OPTS=/\0-Xdoclint:none /g' Makefile.am || die
	fi

	eautoreconf
	cargo_gen_config
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
		--with-itw-libs=DISTRIBUTION
		$(use_enable doc docs)
		$(use_enable nsplugin native-plugin)
		$(use_with javascript rhino)
		$(use_with tagsoup tagsoup "${tagsoup}")
	)

	# See bug #573060.
	xdg_environment_reset

	# Rely on the --with-jdk-home option given above.
	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS

	CONFIG_SHELL="${BASH}" econf "${config[@]}"
}

src_compile() {
	emake CARGO_HOME="${ECARGO_HOME}"
}

src_install() {
	default
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
