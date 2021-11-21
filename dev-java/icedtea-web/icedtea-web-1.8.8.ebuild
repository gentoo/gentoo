# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

README_GENTOO_SUFFIX="-r2"
CRATES="dunce-0.1.1"

inherit autotools bash-completion-r1 cargo readme.gentoo-r1 xdg-utils

DESCRIPTION="FOSS Java browser plugin and Web Start implementation"
HOMEPAGE="https://github.com/AdoptOpenJDK/IcedTea-Web"
SRC_URI="https://github.com/AdoptOpenJDK/${PN}/archive/${P}.tar.gz
	$(cargo_crate_uris ${CRATES})"
LICENSE="GPL-2 GPL-2-with-linking-exception LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"
IUSE="doc"

# tests require ton of java deps we don't have packaged/working
# but rust tests pass.
RESTRICT="test"

BDEPEND="
	app-arch/zip
	sys-devel/bc
	virtual/jdk:1.8
	virtual/pkgconfig
	virtual/rust
	doc? ( sys-devel/bc )
"

RDEPEND="
	>=app-eselect/eselect-java-0.2.0
	>=virtual/jre-1.8
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
	local myconf=(
		--disable-native-plugin
		--program-transform-name='s/^javaws$/itweb-javaws/'
		--with-java="${EPREFIX}/usr/bin/java"
		--with-jdk-home="${EPREFIX}/etc/java-config-2/current-system-vm"
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
	rm -v "${ED}/usr/bin/itw-modularjdk.args" || die
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
