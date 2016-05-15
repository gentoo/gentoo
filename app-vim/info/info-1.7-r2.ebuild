# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit vim-plugin

DESCRIPTION="vim plugin: GNU info documentation browser"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=21"
LICENSE="BSD"
KEYWORDS="~x86 ~alpha ~sparc ~ia64 ~ppc ~s390 ~amd64"
IUSE=""

VIM_PLUGIN_HELPTEXT="This plugin adds the :Info command."

src_prepare() {
	default

	# The 'h' key is a bad choice for help.  'H' would have been a
	# much better choice.  I sent this suggestion to the maintainer,
	# but no reply.
	sed -i 's/\(noremap <buffer> \)h/\1H/' plugin/info.vim || die 'sed failed'
}
