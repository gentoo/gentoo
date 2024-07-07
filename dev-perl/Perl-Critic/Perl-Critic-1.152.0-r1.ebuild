# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PETDANCE
DIST_VERSION=1.152
inherit perl-module elisp-common

DESCRIPTION="Critique Perl source code for best-practices"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~sparc x86"
IUSE="minimal examples emacs"

SITEFILE="50${PN}-gentoo.el"

RDEPEND="
	>=dev-perl/B-Keywords-1.230.0
	virtual/perl-Carp
	>=dev-perl/Config-Tiny-2
	>=dev-perl/Exception-Class-1.230.0
	>=virtual/perl-Exporter-5.630.0
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/File-Which
	virtual/perl-Getopt-Long
	dev-perl/List-SomeUtils
	>=dev-perl/Module-Pluggable-3.100.0
	>=dev-perl/PPI-1.277.0
	dev-perl/PPIx-QuoteLike
	>=dev-perl/PPIx-Regexp-0.80.0
	dev-perl/PPIx-Utils
	dev-perl/Pod-Parser
	>=dev-perl/Pod-Spell-1
	>=dev-perl/Readonly-2
	virtual/perl-Scalar-List-Utils
	>=dev-perl/String-Format-1.180.0
	>=virtual/perl-Term-ANSIColor-2.20.0
	>=virtual/perl-Test-Simple-0.920.0
	>=virtual/perl-Text-ParseWords-3
	dev-perl/Perl-Tidy
	>=virtual/perl-version-0.770.0
	emacs? ( >=app-editors/emacs-23.1:* )
"
BDEPEND="
	${RDEPEND}
	>=dev-perl/Module-Build-0.420.400
	test? (
		dev-perl/Test-Deep
		!minimal? (
			dev-perl/Test-Memory-Cycle
		)
	)
"

src_compile() {
	perl-module_src_compile
	if use emacs; then
		elisp-compile extras/perlcritic.el
	fi
}

src_install() {
	perl-module_src_install
	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		docinto examples/
		dodoc -r examples/*
	fi
	if use emacs; then
		ewarn "USE=emacs: perlcritic-mode is broken upstream, but is installed anyway"
		ewarn " https://github.com/Perl-Critic/Perl-Critic/issues/682"
		elisp-install ${PN} extras/perlcritic.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
