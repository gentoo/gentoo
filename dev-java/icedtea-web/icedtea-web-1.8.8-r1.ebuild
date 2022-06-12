# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

README_GENTOO_SUFFIX="-r3"
CRATES="dunce-0.1.1"

inherit autotools bash-completion-r1 cargo java-pkg-2 readme.gentoo-r1 xdg-utils

DESCRIPTION="FOSS Java browser plugin and Web Start implementation"
HOMEPAGE="https://github.com/AdoptOpenJDK/IcedTea-Web"
SRC_URI="https://github.com/AdoptOpenJDK/${PN}/archive/${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
LICENSE="GPL-2 GPL-2-with-linking-exception LGPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE="doc"

# tests require ton of java deps we don't have packaged/working
# but rust tests pass.
RESTRICT="test"

BDEPEND="
	app-arch/zip
	sys-devel/bc
	virtual/pkgconfig
	virtual/rust
	doc? ( sys-devel/bc )
"

# Build within Portage using JDK 11+ (also presumably 9+) fails during
# src_configure:
#	configure: error: sun.security.util.SecurityConstants not found.
#
# When upstream's build instructions are executed outside Portage using
# JDK 11+, ./configure also fails, though a different error pops up:
#	configure: error: sun.applet.AppletImageRef not found.
#
# If even the upstream build instructions fail outside Portage with JDK 11+,
# then it is very unlikely that the build issue within Portage is fixable.
# The upstream has moved forward to development of 2.0.0 and 3.0.0 versions,
# so they might no longer be interested in fixing the legacy 1.x versions.
#
# The 'sun.applet.AppletImageRef not found' issue has been reported to
# FreeBSD <https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=248197#c2>,
# and some efforts there to fix the issue were unsuccessful.  They seem
# to have ended up with restricting Java version to 8
# <https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=244976#c17>.
#
# Thus, the build VM version is restricted to 1.8 here.
DEPEND="
	virtual/jdk:1.8
"

RDEPEND="
	>=app-eselect/eselect-java-0.2.0
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/IcedTea-Web-${P}"

QA_FLAGS_IGNORED="usr/bin/.*"

src_prepare() {
	eapply_user
	sed -i 's/JAVADOC_OPTS=/\0-Xdoclint:none /g' Makefile.am || die
	eautoreconf
	cargo_gen_config
}

src_configure() {
	xdg_environment_reset
	# some functionality (tagsoup rhino) is disabled, because dev-java is
	# unmaintained and a lot of things simply does not build anymore.
	# native plugins also disabled, modern browsers no longer support it.
	# modularjdk-file and the 'itw-modularjdk.args' file controlled by it
	# are required to run this package's programs using JRE 9+.
	local myconf=(
		--disable-native-plugin
		--program-transform-name='s/^javaws$/itweb-javaws/'
		--with-jdk-home="$(java-config -O)"
		--with-modularjdk-file="${EPREFIX}/usr/share/${PN}/"
		--with-itw-libs=DISTRIBUTION
		--without-rhino
		--without-tagsoup
		$(use_enable doc docs)
	)
	unset _JAVA_OPTIONS
	export bashcompdir="$(get_bashcompdir)" # defaults to /etc if not found in pkg-config
	export CARGO_HOME="${ECARGO_HOME}"
	CONFIG_SHELL="${EPREFIX}/bin/bash" econf "${myconf[@]}"
}

src_compile() {
	# races in makefile
	emake -j1 #nowarn
}

src_install() {
	default
	rename -v '.bash' '' "${ED}/usr/share/bash-completion/completions/"*.bash || die
	rename -v 'javaws' 'itweb-javaws' "${ED}/usr/share/man/man1/"javaws.1* || die
	mv -v "${ED}/usr/share/bash-completion/completions/"{javaws,itweb-javaws} || die
	sed -i 's/javaws/itweb-javaws/g' \
		"${ED}/usr/share/bash-completion/completions/itweb-javaws" || die

	readme.gentoo_create_doc
}

src_test() {
	# we want to override cargo.eclass' src_test
	:
}

pkg_postinst() {
	readme.gentoo_print_elog
}
