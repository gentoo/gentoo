# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
USE_RUBY="ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="A ruby library for creating NFS safe lockfiles"
HOMEPAGE="https://github.com/ahoward/lockfile"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
