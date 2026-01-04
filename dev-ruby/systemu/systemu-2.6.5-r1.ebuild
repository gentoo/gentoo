# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34 ruby40"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Universal capture of STDOUT and STDERR and handling of child process PID"
HOMEPAGE="https://github.com/ahoward/systemu"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

all_ruby_install() {
	all_fakegem_install

	dodoc -r samples
}
