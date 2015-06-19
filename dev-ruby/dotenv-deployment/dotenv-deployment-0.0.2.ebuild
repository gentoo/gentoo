# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/dotenv-deployment/dotenv-deployment-0.0.2.ebuild,v 1.2 2015/03/20 13:44:19 graaff Exp $

EAPI=5
USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_EXTRADOC="README.md Changelog.md"
RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_RECIPE_DOC="rdoc"

inherit ruby-fakegem

DESCRIPTION="Deployment concerns for dotenv"
HOMEPAGE="https://github.com/bkeepers/dotenv-deployment"
LICENSE="MIT"

KEYWORDS="~amd64"
SLOT="0"
IUSE=""
