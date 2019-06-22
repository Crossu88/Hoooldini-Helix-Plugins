local CW20BASE = weapons.GetStored("cw_base")

function CW20BASE:detachSpecificAttachment(attachmentName)
	-- since we don't know the category, we'll just have to iterate over all attachments, find the one we want, and dettach it there
	for category, data in pairs(self.Attachments) do
		for key, attachment in ipairs(data.atts) do
			if attachment == attachmentName then
				self:detach(category, key - 1, false)
			end
		end
	end
end