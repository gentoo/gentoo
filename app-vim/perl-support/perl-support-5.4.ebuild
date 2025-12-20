# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit vim-plugin

DESCRIPTION="vim plugin: Perl-IDE - Write and run Perl scripts using menus and hotkeys"
HOMEPAGE="https://www.vim.org/scripts/script.php?script_id=556"
SRC_URI="https://github.com/WolfgangMehner/perl-support/archive/version-${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2 GPL-2+"
KEYWORDS="amd64 ppc x86"

VIM_PLUGIN_HELPFILES="perlsupport.txt"

RDEPEND="
	!ppc? ( dev-perl/Devel-NYTProf )
	dev-perl/Perl-Tidy
	dev-perl/Perl-Tags
	dev-perl/Perl-Critic"

S="${WORKDIR}/${PN}-version-${PV}"

src_prepare() {
	# Don't set tabstop and shiftwidth
	sed -i '/=4/s/^/"/' ftplugin/perl.vim || die
	default
}

src_install() {
	dodoc ${PN}/doc/{ChangeLog,perl-hot-keys.pdf}
	rm -r ${PN}/doc/ || die

	vim-plugin_src_install
}

pkg_postinst() {
	elog "${PN} can utilize the following modules on top of the ones installed as"
	elog "dependencies:"
	elog
	elog "Devel::SmallProf     - per-line Perl profiler"
	elog "Devel::FastProf      - per-line Perl profiler"
	elog "Devel::ptkdb         - Perl debugger using a Tk GUI"
	elog "Pod::Pdf             - A POD to PDF translator"
	elog "YAPE::Regex::Explain - regular expression analyzer"
	elog
	elog "You may need to install them separately if you would like to use them."
}
