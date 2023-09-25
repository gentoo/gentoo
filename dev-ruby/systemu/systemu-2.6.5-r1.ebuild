# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby27 ruby30 ruby31 ruby32"

RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README"

inherit ruby-fakegem

DESCRIPTION="Universal capture of STDOUT and STDERR and handling of child process PID"
HOMEPAGE="http://codeforpeople.com/lib/ruby/systemu/"

LICENSE="Ruby-BSD"
SLOT="0"
KEYWORDS="amd64 ~riscv x86"

all_ruby_install() {
	all_fakegem_install

	dodoc -r samples
}
