# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

DESCRIPTION="A Django application for managing hierarchical pages of content"
HOMEPAGE="https://www.django-cms.org/"
SRC_URI="https://github.com/divio/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE="+admin-style +ckeditor file flash inherit link picture snippet teaser video"
REQUIRED_USE="admin-style ckeditor"

RDEPEND="
	>=dev-python/django-1.6.9
	admin-style? ( dev-python/djangocms-admin-style )
	file? ( dev-python/djangocms-file )
	flash? ( dev-python/djangocms-flash )
	inherit? ( dev-python/djangocms-inherit )
	link? ( dev-python/djangocms-link )
	picture? ( dev-python/djangocms-picture )
	snippet? ( dev-python/djangocms-snippet )
	teaser? ( dev-python/djangocms-teaser )
	video? ( dev-python/djangocms-video )
	>=dev-python/django-classy-tags-0.5
	>=dev-python/django-sekizai-0.7
	ckeditor? ( >=dev-python/djangocms-text-ckeditor-2.1.1 )
	dev-python/django-treebeard
	dev-python/html5lib
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools
"
