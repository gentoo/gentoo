# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

inherit vim-plugin

DESCRIPTION="vim plugin: Puppet configuration files syntax"
HOMEPAGE="http://puppetlabs.com/"
SRC_URI="https://dev.gentoo.org/~tampakrap/tarballs/${P}.tar.gz"
LICENSE="Apache-2.0 GPL-2"
KEYWORDS="amd64 ~arm hppa ppc ~ppc64 sparc x86 ~amd64-linux ~x64-macos ~x64-solaris"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for Puppet configuration
files."

DEPEND="!<app-admin/puppet-3.0.1"
RDEPEND=${DEPEND}
