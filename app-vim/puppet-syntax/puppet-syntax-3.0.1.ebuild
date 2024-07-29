# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vim-plugin

DESCRIPTION="vim plugin: Puppet configuration files syntax"
HOMEPAGE="http://puppetlabs.com/"
SRC_URI="https://dev.gentoo.org/~tampakrap/tarballs/${P}.tar.gz"
LICENSE="Apache-2.0 GPL-2"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ppc ~ppc64 ~riscv sparc x86 ~amd64-linux ~x64-macos ~x64-solaris"

VIM_PLUGIN_HELPTEXT=\
"This plugin provides syntax highlighting for Puppet configuration
files."

DEPEND="!<app-admin/puppet-3.0.1"
RDEPEND=${DEPEND}
