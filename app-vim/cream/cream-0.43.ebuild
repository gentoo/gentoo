# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit vim-plugin eutils fdo-mime

DESCRIPTION="An easy-to-use configuration of the GVim text editor"
HOMEPAGE="http://cream.sourceforge.net"

DICT_EN="eng_2.0.2"
DICT_FR="fre_2.1"
DICT_ES="spa_3.0"
DICT_DE="ger_2.0.1"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz
	linguas_en? ( ${HOMEPAGE}/cream-spell-dict-${DICT_EN}.zip )
	linguas_fr? ( ${HOMEPAGE}/cream-spell-dict-${DICT_FR}.zip )
	linguas_es? ( ${HOMEPAGE}/cream-spell-dict-${DICT_ES}.zip )
	linguas_de? ( ${HOMEPAGE}/cream-spell-dict-${DICT_DE}.zip )"

IUSE="linguas_en linguas_fr linguas_es linguas_de"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ~mips ppc sparc x86"

DEPEND="
	>=app-editors/gvim-7.0
	app-arch/unzip"
RDEPEND="
	>=app-editors/gvim-7.0
	dev-util/ctags"

VIM_PLUGIN_HELPTEXT=\
"Cream is completely independent from the rest of your Vim/GVim setup.
To launch GVim in Cream mode, use this wrapper script:
\    % cream [filename...]

Cream's documentation has been installed in ${ROOT}usr/share/doc/${PF}
In particular, you may want to read:

\ - the Cream features list:
file://${ROOT}usr/share/doc/${PF}/html/features.html

\ - the Cream shortcuts list:
file://${ROOT}usr/share/doc/${PF}/html/keyboardshortcuts.html

\ - the Cream FAQ:
file://${ROOT}usr/share/doc/${PF}/html/faq.html"

# Utility function to rename a Vim help file and its links/anchors:
#   prefix_help_file prefix file [pattern ...]
prefix_help_file() {
	local prefix="${1}" ; shift
	local helpfile="${1}" ; shift
	while [[ -n "${1}" ]] ; do
		sed -i "s:\([*|]\)\(${1}[*|]\):\1${prefix}-\2:g" "${helpfile}" \
			|| die "Failed to sed \"${1}\" on \"${helpfile}\""
		shift
	done
	mv "${helpfile}" "${helpfile%/*}/${prefix}-${helpfile##*/}" \
		|| die "Failed to rename \"${helpfile}\""
}

pkg_setup() {
	elog "Cream comes with several dictionaries for spell checking. In"
	elog "all cases, at least a small English dictionary will be installed."
	elog
	elog "To specify which optional dictionaries are installed, set the"
	elog "LINGUAS variable in /etc/make.conf. For example, to install full"
	elog "English and French dictionaries, use:"
	elog "    LINGUAS=\"en fr\""
	elog
	elog "Available dictionaries are:"
	for dict in "English en" "French fr" "German de" "Spanish es" ; do
		# portage bug: shouldn't get a QA notice for linguas stuff...
		elog "    ${dict% *} \t(${dict#* }) $( ( \
			use linguas_${dict#* } &>/dev/null && \
			echo '(Will be installed)' ) || echo '(Will not be installed)' )"
	done
	elog
}

src_unpack() {
	mkdir -p "${S}"/spelldicts

	# install spell dictionaries into ${S}/spelldicts
	local my_a
	for my_a in ${A} ; do
		if [ -z ${my_a/*spell-dict*/} ] ; then
			cd "${S}"/spelldicts
			unpack ${my_a}
		else
			cd "${WORKDIR}"
			unpack ${my_a}
		fi
	done
}

src_prepare() {
	# change installation path + fix the wrapper command (disable plugins)
	cat > cream <<-EOF
	#!/bin/sh
	gvim --servername CREAM --noplugin -U NONE -u "\\\$VIM/cream/creamrc" "\$@"
	EOF

	sed -i "/let \$CREAM/s:VIMRUNTIME:VIM:" creamrc || die

	# make taglist ebuild aware, bug #66052
	epatch "${FILESDIR}"/${PN}-0.30-ebuilds.patch

	# more filetypes for EnhancedCommentify, including the Gentoo ones
	epatch "${FILESDIR}"/enhancedcommentify-2.1-gentooisms.patch
	epatch "${FILESDIR}"/enhancedcommentify-2.1-extra-ft-support.patch

	# rename vim help files to avoid conflicts with other vim packages
	prefix_help_file cream help/EnhancedCommentify.txt \
		'EnhancedCommentify' 'EnhComm-[a-zA-Z]\+'

}

src_install() {
	# install launcher and menu entry
	dobin cream
	domenu cream.desktop
	doicon cream.svg cream.png

	# install shared vim files
	insinto /usr/share/vim/cream
	doins *.vim creamrc
	local dir
	for dir in addons bitmaps filetypes lang ; do
		insinto /usr/share/vim/cream/${dir}
		doins ${dir}/*
	done

	if [[ -n ${LINGUAS} ]] ; then
		insinto /usr/share/vim/cream/spelldicts
		doins spelldicts/*
	fi

	insinto /usr/share/vim/vimfiles/doc
	doins help/*.txt

	# install docs
	dodoc docs/{CHANGELOG,DEVELOPER,KEYBOARD,PressRelease,README,RELEASE}.txt
	dohtml docs-html/*
	# html doc may be opened from Cream GUI
	dosym ../../doc/${PF}/html /usr/share/vim/cream/docs-html
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	vim-plugin_pkg_postinst
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	vim-plugin_pkg_postrm
}
