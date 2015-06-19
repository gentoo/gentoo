# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/cri/cri-2.4.1.ebuild,v 1.4 2014/11/04 17:26:48 mrueg Exp $

EAPI=5
USE_RUBY="ruby19 ruby20"

RUBY_FAKEGEM_EXTRADOC="NEWS.md README.md"

RUBY_FAKEGEM_TASK_DOC="doc"

inherit ruby-fakegem

DESCRIPTION="Cri is a library for building easy-to-use commandline tools"
HOMEPAGE="http://rubygems.org/gems/cri"
LICENSE="MIT"

KEYWORDS="~amd64 ~x86 ~x86-fbsd"
SLOT="0"
IUSE=""

ruby_add_rdepend ">=dev-ruby/colored-1.2"

ruby_add_bdepend "doc? ( dev-ruby/yard )
	test? ( dev-ruby/yard dev-ruby/minitest )"
