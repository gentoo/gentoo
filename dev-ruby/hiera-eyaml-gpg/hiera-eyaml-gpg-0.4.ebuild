# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/hiera-eyaml-gpg/hiera-eyaml-gpg-0.4.ebuild,v 1.1 2015/02/12 01:23:41 robbat2 Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="A GPG backend for hiera-eyaml"
HOMEPAGE="https://github.com/sihil/hiera-eyaml-gpg"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

ruby_add_rdepend '>=dev-ruby/hiera-eyaml-1.3.8'
ruby_add_rdepend '>=dev-ruby/gpgme-2.0.0'
