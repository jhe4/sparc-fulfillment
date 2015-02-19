json.(participant)

json.name participant.first_name + ' ' + participant.last_name
json.id participant.id
json.status participant.status
json.protocol_sparc_id participant.protocol.sparc_id

if participant.arm
  json.arm participant.arm.name
else
  json.arm 'None'
end