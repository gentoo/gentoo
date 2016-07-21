# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

USE_RUBY="jruby"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem eutils

DESCRIPTION="BiteScript is a Ruby DSL for generating Java bytecode and classes"
HOMEPAGE="http://kenai.com/projects/bitescript"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/*
}
