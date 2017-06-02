# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_{3,4}} )

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
	>=dev-python/django-1.8[${PYTHON_USEDEP}]
	admin-style? ( >=dev-python/djangocms-admin-style-1.0[${PYTHON_USEDEP}] )
	file? ( dev-python/djangocms-file[${PYTHON_USEDEP}] )
	flash? ( dev-python/djangocms-flash[${PYTHON_USEDEP}] )
	inherit? ( dev-python/djangocms-inherit[${PYTHON_USEDEP}] )
	link? ( dev-python/djangocms-link[${PYTHON_USEDEP}] )
	picture? ( dev-python/djangocms-picture[${PYTHON_USEDEP}] )
	snippet? ( dev-python/djangocms-snippet[${PYTHON_USEDEP}] )
	teaser? ( dev-python/djangocms-teaser[${PYTHON_USEDEP}] )
	video? ( dev-python/djangocms-video[${PYTHON_USEDEP}] )
	>=dev-python/django-classy-tags-0.7[${PYTHON_USEDEP}]
	>=dev-python/django-formtools-1.0[${PYTHON_USEDEP}]
	>=dev-python/django-sekizai-0.7[${PYTHON_USEDEP}]
	ckeditor? ( >=dev-python/djangocms-text-ckeditor-3.2.0[${PYTHON_USEDEP}] )
	>=dev-python/django-treebeard-4.0[${PYTHON_USEDEP}]
	dev-python/html5lib[${PYTHON_USEDEP}]
"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
