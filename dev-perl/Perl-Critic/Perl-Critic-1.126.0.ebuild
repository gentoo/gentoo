# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=THALJEF
DIST_VERSION=1.126
inherit perl-module elisp-common

DESCRIPTION="Critique Perl source code for best-practices"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test minimal examples emacs"
SITEFILE="50${PN}-gentoo.el"
RDEPEND="
	>=dev-perl/B-Keywords-1.50.0
	virtual/perl-Carp
	>=dev-perl/Config-Tiny-2
	>=dev-perl/Email-Address-1.889.0
	>=dev-perl/Exception-Class-1.230.0
	>=virtual/perl-Exporter-5.630.0
	dev-perl/File-HomeDir
	virtual/perl-File-Path
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	dev-perl/File-Which
	virtual/perl-Getopt-Long
	dev-perl/IO-String
	>=dev-perl/List-MoreUtils-0.190.0
	>=dev-perl/Module-Pluggable-3.100.0
	>=dev-perl/PPI-1.220
	>=dev-perl/PPIx-Regexp-0.27.0
	>=dev-perl/PPIx-Utilities-1.1.0
	virtual/perl-Pod-Parser
	>=dev-perl/Pod-Spell-1
	>=dev-perl/Readonly-2
	virtual/perl-Scalar-List-Utils
	>=dev-perl/String-Format-1.130.0
	dev-perl/Task-Weaken
	>=virtual/perl-Term-ANSIColor-2.20.0
	>=virtual/perl-Test-Simple-0.920.0
	>=virtual/perl-Text-ParseWords-3
	dev-perl/Perl-Tidy
	>=virtual/perl-version-0.770.0
	emacs? ( virtual/emacs )
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.402.400
	test? (
		dev-perl/Test-Deep
		!minimal? (
			dev-perl/Test-Memory-Cycle
		)
	)"

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
