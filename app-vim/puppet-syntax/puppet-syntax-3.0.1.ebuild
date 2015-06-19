# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/puppet-syntax/puppet-syntax-3.0.1.ebuild,v 1.8 2014/02/09 18:47:23 grobian Exp $

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: Puppet configuration files syntax"
HOMEPAGE="http://puppetlabs.com/"
SRC_URI="http://dev.gentoo.org/~tampakrap/tarballs/${P}.tar.gz"
LICENSE="Apache-2.0 GPL-2"
KEYWORDS="amd64 hppa ppc sparc x86 ~x64-macos ~x64-solaris"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for Puppet configuration
files."

DEPEND="!<app-admin/puppet-3.0.1"
RDEPEND=${DEPEND}
