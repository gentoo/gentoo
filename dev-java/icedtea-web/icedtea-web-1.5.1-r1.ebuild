# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
# Build written by Andrew John Hughes (ahughes@redhat.com)

EAPI="5"

inherit autotools eutils readme.gentoo java-pkg-2 java-vm-2

DESCRIPTION="FOSS Java browser plugin and Web Start implementation"
HOMEPAGE="http://icedtea.classpath.org"
SRC_URI="http://icedtea.classpath.org/download/source/${P}.tar.gz"
LICENSE="GPL-2 GPL-2-with-linking-exception LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~ppc64 x86"
IUSE="doc +icedtea7 javascript nsplugin tagsoup test"
RESTRICT="test"

COMMON_DEP="
	icedtea7? ( || (
		dev-java/icedtea:7 dev-java/icedtea-bin:7
	) )
	!icedtea7? ( || (
		dev-java/icedtea:7 dev-java/icedtea-bin:7
		dev-java/icedtea:6 dev-java/icedtea-bin:6
	) )
	app-eselect/eselect-java
	tagsoup? ( dev-java/tagsoup )
	nsplugin? (
		>=dev-libs/glib-2.16
	)"
RDEPEND="${COMMON_DEP}"
# Need system junit 4.8+. Bug #389795
DEPEND="${COMMON_DEP}
	virtual/pkgconfig
	app-arch/zip
	javascript? ( dev-java/rhino:1.6 )
	nsplugin? ( net-misc/npapi-sdk )
	test? (	>=dev-java/junit-4.8:4 )"

# http://mail.openjdk.java.net/pipermail/distro-pkg-dev/2010-December/011221.html
pkg_setup() {
	JAVA_PKG_WANT_BUILD_VM="icedtea-7 icedtea-bin-7"
	if ! use icedtea7; then
		JAVA_PKG_WANT_BUILD_VM="${JAVA_PKG_WANT_BUILD_VM} icedtea-6 icedtea-bin-6"
	fi
	JAVA_PKG_WANT_SOURCE="1.6"
	JAVA_PKG_WANT_TARGET="1.6"

	java-pkg-2_pkg_setup
	java-vm-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.5-respect-ldflags.patch # bug #356645
	eautoreconf
}

src_configure() {
	local tagsoup_jar
	local config

	# bug #527962
	use tagsoup && tagsoup_jar="$(java-pkg_getjars tagsoup)"

	config=(
		# javaws is managed by eselect java-vm and symlinked to by icedtea so
		# move it out of the way and symlink itweb-settings back to bin
		--bindir="${EPREFIX}"/usr/libexec/${PN}
		--with-jdk-home="${JAVA_HOME}"
		$(use_enable doc docs)
		$(use_enable nsplugin plugin)
		$(use_with javascript rhino)
		$(use_with tagsoup tagsoup ${tagsoup_jar})
	)

	unset JAVA_HOME JDK_HOME CLASSPATH JAVAC JAVACFLAGS
	econf "${config[@]}"
}

src_compile() {
	default
}

src_install() {
	default

	if use nsplugin; then
		install_mozilla_plugin "/usr/$(get_libdir)/IcedTeaPlugin.so"
	fi

	mkdir -p "${ED}"/usr/bin || die
	dosym /usr/libexec/${PN}/itweb-settings /usr/bin/itweb-settings || die

	# Should we patch system default lookup instead?
	mkdir -p "${ED}"/etc/.java/deployment/ || die
	echo "deployment.jre.dir=/etc/java-config-2/current-icedtea-web-vm" \
		> "${ED}"/etc/.java/deployment/deployment.properties || die

	readme.gentoo_create_doc
}

pkg_postinst() {
	VMHANDLE="icedtea-web@${GENTOO_VM}" java-vm_check-nsplugin
	java_mozilla_clean_
	readme.gentoo_print_elog
}

pkg_prerm() {
	# override the java-vm-2 eclass check for removing a system VM, as it
	# doesn't make sense here.
	:;
}
