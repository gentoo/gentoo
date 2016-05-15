# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby20 ruby21 ruby22 ruby23"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="A ruby library for creating NFS safe lockfiles"
HOMEPAGE="https://github.com/ahoward/lockfile"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
