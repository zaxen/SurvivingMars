-- ========== THIS IS AN AUTOMATICALLY GENERATED FILE! ==========

PlaceObj('XTemplate', {
	group = "Infopanel Sections",
	id = "ipGridConstruction",
	PlaceObj('XTemplateTemplate', {
		'__template', "Infopanel",
		'Description', T{10, --[[XTemplate ipGridConstruction Description]] "<Description>"},
	}, {
		PlaceObj('XTemplateTemplate', {
			'__template', "InfopanelSection",
			'RolloverText', T{907, --[[XTemplate ipGridConstruction RolloverText]] "Issues related to the placement of this building."},
			'Title', T{49, --[[XTemplate ipGridConstruction Title]] "Status"},
			'Icon', "UI/Icons/Sections/warning.tga",
		}, {
			PlaceObj('XTemplateTemplate', {
				'__template', "InfopanelText",
				'Text', T{969016274382, --[[XTemplate ipGridConstruction Text]] "<construction_statuses_property>"},
			}),
			}),
		PlaceObj('XTemplateTemplate', {
			'comment', "control hints",
			'__template', "InfopanelSection",
			'RolloverText', T{894, --[[XTemplate ipGridConstruction RolloverText]] "List of applicable shortcuts and what they do."},
			'Title', T{893, --[[XTemplate ipGridConstruction Title]] "Control hints"},
			'Icon', "UI/Icons/Sections/attention.tga",
		}, {
			PlaceObj('XTemplateGroup', {
				'__condition', function (parent, context) return not GetUIStyleGamepad() end,
			}, {
				PlaceObj('XTemplateTemplate', {
					'__template', "InfopanelText",
					'Text', T{908, --[[XTemplate ipGridConstruction Text]] "<left_click> Place"},
				}),
				PlaceObj('XTemplateTemplate', {
					'__template', "InfopanelText",
					'Text', T{909, --[[XTemplate ipGridConstruction Text]] "<right_click> Cancel"},
				}),
				}),
			PlaceObj('XTemplateGroup', {
				'__condition', function (parent, context) return GetUIStyleGamepad() end,
			}, {
				PlaceObj('XTemplateTemplate', {
					'__template', "InfopanelText",
					'Text', T{914, --[[XTemplate ipGridConstruction Text]] "<ButtonA> Place"},
				}),
				PlaceObj('XTemplateTemplate', {
					'__template', "InfopanelText",
					'Text', T{915, --[[XTemplate ipGridConstruction Text]] "<ButtonB> Cancel"},
				}),
				}),
			}),
		}),
})

